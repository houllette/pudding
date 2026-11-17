defmodule Pudding.Project.Inspection do
  @moduledoc """
  BEAM capture inside a controlled inspector, without a Lynx private API bridge.

  Preflight reads every build BEAM before any debug callback executes. Core is
  reconstructed only with the pinned OTP/Elixir callbacks. This is provenance,
  not a translator or a resolved verification closure. The latter requires a
  supported upstream API; capture explicitly records that gate as blocked.
  """
  alias Pudding.Project.Beam
  alias Pudding.Project.Manifest

  @doc "Captures all build bytes and reconstructs explicitly requested modules."
  @spec collect(request :: map(), build :: Path.t(), output :: Path.t()) :: map()
  def collect(request, build, output) do
    File.mkdir_p!(output)
    files = inventory(build, output, "/workspace/" <> request["project"] <> "/_build")
    writable = capture_writable(request, build, output)

    targets =
      files
      |> Enum.filter(
        &(&1["type"] == "regular" and String.ends_with?(&1["name"], ".beam") and
            Path.basename(Path.dirname(&1["name"])) == "ebin")
      )
      |> Enum.map(&Path.join(build, String.replace_prefix(&1["name"], "build/", "")))
      |> Enum.sort()

    candidates = Enum.map(targets, &candidate/1)

    Enum.each(candidates, fn captured ->
      captured["path"] |> external_resources() |> Enum.each(&resource!(request, build, &1))
    end)

    {:ok, index} = Beam.index(candidates)

    preflights =
      Map.new(candidates, fn candidate ->
        {:ok, pre} = Beam.preflight(File.read!(candidate["path"]))
        {candidate["module"], pre}
      end)

    Enum.each(request["roots"], &assert_root!(&1, index))

    requested = Enum.uniq(Enum.map(request["roots"], & &1["module"]) ++ request["laws"])

    modules =
      Enum.map(requested, fn name ->
        captured = Map.fetch!(index, name)
        pre = Map.fetch!(preflights, name)
        {:ok, core} = Beam.reconstruct(pre)
        prefix = "modules/" <> name
        write(output, prefix <> ".beam", File.read!(captured["path"]))
        write(output, prefix <> ".debug.raw", Map.fetch!(pre.chunks, ~c"Dbgi"))
        write(output, prefix <> ".compile.raw", Map.fetch!(pre.chunks, ~c"CInf"))
        write(output, prefix <> ".core.etf", :erlang.term_to_binary(core, [:deterministic]))
        write(output, prefix <> ".core", IO.iodata_to_binary(:core_pp.format(core)))
        source = pre.compile_info |> Keyword.get(:source, ~c"unknown") |> to_string()
        resources = Enum.map(external_resources(captured["path"]), &resource!(request, build, &1))

        Map.merge(captured, %{
          "source" => source,
          "external_resources" => resources,
          "backend" => Atom.to_string(pre.backend),
          "backend_options" => [],
          "backend_version" => backend_version(pre.backend),
          "compile_info" => inspect(pre.compile_info, limit: :infinity)
        })
      end)
      |> Enum.sort_by(& &1["module"])

    runtime =
      Enum.map([:lists], fn module ->
        bytes = File.read!(:code.which(module))
        {:ok, _preflight} = Beam.preflight(bytes)
        write(output, "runtime/#{module}.beam", bytes)
        %{"module" => Atom.to_string(module), "sha256" => Manifest.digest(bytes)}
      end)

    metadata = %{
      "runtime_proof_candidates" => runtime,
      "modules" => modules,
      "build_files" => files,
      "writable_outputs" => writable,
      "preflight" => candidates,
      "toolchain" => toolchain(),
      "callback_policy" => ["elixir_erl", "erl_abstract_code"],
      "reconstruction" => "core_v1",
      "reconstruction_options" => [],
      "assurance" => "captured_not_proved",
      "closure_gate" => "blocked_supported_lynx_api_required",
      "freshness" =>
        if(request["unknown_inputs"] == [], do: "controlled_inputs_only", else: "unknown_inputs")
    }

    write(output, "inspection.json", Manifest.canonical(metadata))
    metadata
  end

  defp assert_root!(root, index) do
    captured = Map.fetch!(index, root["module"])

    {:ok, {_module, [exports: exports]}} =
      :beam_lib.chunks(String.to_charlist(captured["path"]), [:exports])

    unless Enum.any?(exports, fn {name, arity} ->
             Atom.to_string(name) == root["function"] and arity == root["arity"]
           end),
           do: raise(ArgumentError, "missing exported root: #{inspect(root)}")
  end

  defp candidate(path) do
    bytes = File.read!(path)
    {:ok, module, _} = :beam_lib.all_chunks(bytes)
    %{"path" => path, "module" => Atom.to_string(module), "sha256" => Manifest.digest(bytes)}
  end

  defp external_resources(path) do
    {:ok, {_module, [attributes: attrs]}} =
      :beam_lib.chunks(String.to_charlist(path), [:attributes])

    attrs |> Keyword.get(:external_resource, []) |> Enum.map(&to_string/1)
  end

  @doc "Resolves an external resource against the captured build's writable mount view."
  @spec resource!(request :: map(), build :: Path.t(), path :: Path.t()) :: map()
  def resource!(request, build, path) do
    expanded = Path.expand(path)
    mounts = [request["project"] <> "/_build" | request["writable_paths"]]

    resolved =
      mounts
      |> Enum.with_index()
      |> Enum.find_value(expanded, fn {relative, n} ->
        prefix = "/workspace/" <> relative <> "/"

        if String.starts_with?(expanded, prefix) do
          Path.join(resource_root(build, n), String.replace_prefix(expanded, prefix, ""))
        end
      end)

    unless String.starts_with?(expanded, "/workspace/") and regular_components?(resolved),
      do: raise(ArgumentError, "undeclared external resource: #{path}")

    %{
      "path" => expanded,
      "sha256" => Manifest.digest(File.read!(resolved)),
      "size" => File.stat!(resolved).size
    }
  end

  defp resource_root(build, 0), do: build
  defp resource_root(build, n), do: Path.join(Path.dirname(build), "generated-#{n}")

  defp regular_components?(path) do
    ["/" | parts] = Path.split(path)

    Enum.reduce_while(parts, "/", fn part, parent ->
      next = Path.join(parent, part)

      case File.lstat(next) do
        {:ok, %{type: type}} when type in [:regular, :directory] -> {:cont, next}
        _ -> {:halt, false}
      end
    end) != false and match?({:ok, %{type: :regular}}, File.lstat(path))
  end

  defp backend_version(backend) do
    %{
      "beam_sha256" => Manifest.digest(File.read!(:code.which(backend))),
      "elixir" => System.version(),
      "otp" => System.otp_release()
    }
  end

  @doc "Captures a bounded output tree and its filesystem-semantic inventory without following links."
  @spec inventory(build :: Path.t(), output :: Path.t(), guest_build :: Path.t()) :: [map()]
  def inventory(build, output, guest_build) do
    {files, _size, _count} = scan(build, "", [], 0, 0, guest_build, :artifacts)

    entries =
      Enum.map(files, fn {relative, path, type} ->
        name = "build/" <> relative

        bytes =
          case type do
            :symlink -> File.read_link!(path)
            :regular -> File.read!(path)
            :directory -> ""
          end

        unless type == :directory, do: write(output, name, bytes)

        %{
          "name" => name,
          "type" => Atom.to_string(type),
          "mode" => Bitwise.band(File.lstat!(path).mode, 0o777),
          "sha256" => Manifest.digest(bytes),
          "size" => byte_size(bytes)
        }
      end)
      |> Enum.sort_by(& &1["name"])

    write(output, "build-inventory.json", Manifest.canonical(entries))
    entries
  end

  defp capture_writable(request, build, output) do
    inventories =
      request["writable_paths"]
      |> Enum.with_index(1)
      |> Map.new(fn {relative, n} ->
        root = Path.join(Path.dirname(build), "generated-#{n}")
        cache? = String.ends_with?(relative, "/.lake")

        {files, _, _} =
          scan(
            root,
            "",
            [],
            0,
            0,
            "/workspace/" <> relative,
            if(cache?, do: :cache, else: :artifacts)
          )

        entries = writable_entries(files, cache?, output, n)

        {relative,
         %{
           "retention" =>
             if(cache?, do: "inventory_only_ephemeral_lake_cache", else: "exact_bytes"),
           "files" => entries
         }}
      end)

    # Inventories are themselves compared, including hashes of ephemeral tool caches.
    write(output, "writable-inventory.json", Manifest.canonical(inventories))
    inventories
  end

  defp writable_entries(files, cache?, output, n) do
    Map.new(files, fn {name, path, type} ->
      if type == :symlink, do: raise(ArgumentError, "unsafe writable output")
      bytes = if type == :directory, do: "", else: File.read!(path)
      unless cache? or type == :directory, do: write(output, "writable/#{n}/" <> name, bytes)

      {name,
       %{
         "type" => Atom.to_string(type),
         "mode" => Bitwise.band(File.lstat!(path).mode, 0o777),
         "sha256" => Manifest.digest(bytes),
         "size" => byte_size(bytes)
       }}
    end)
  end

  defp scan(_root, prefix, _files, _size, _count, _guest, _mode) when byte_size(prefix) > 2048,
    do: raise(ArgumentError, "build output depth limit")

  defp scan(root, prefix, files, size, count, guest, mode) do
    if length(Path.split(prefix)) > 64, do: raise(ArgumentError, "build output depth limit")

    Enum.reduce(Enum.sort(File.ls!(root)), {files, size, count}, fn name, {files, size, count} ->
      scan_entry(root, prefix, name, files, size, count, guest, mode)
    end)
  end

  defp scan_entry(root, prefix, name, files, size, count, guest, mode) do
    path = Path.join(root, name)
    relative = Path.join(prefix, name)
    max_bytes = if mode == :cache, do: 1_073_741_824, else: 60_000_000
    if count >= 20_000, do: raise(ArgumentError, "build output count limit")

    case File.lstat!(path) do
      %{type: :directory} ->
        scan(path, relative, [{relative, path, :directory} | files], size, count + 1, guest, mode)

      %{type: :regular, size: length} when size + length <= max_bytes ->
        {[{relative, path, :regular} | files], size + length, count + 1}

      %{type: :symlink} ->
        check_link!(name, path, relative, guest)
        {[{relative, path, :symlink} | files], size, count + 1}

      _ ->
        raise ArgumentError, "unsafe or oversized build output: #{relative}"
    end
  end

  defp check_link!(name, path, relative, guest) do
    # Mix links are relative to their build-time mount, not /work/build in the inspector.
    target = Path.expand(File.read_link!(path), Path.dirname(Path.join(guest, relative)))

    unless name == "priv" and String.starts_with?(target, "/workspace/"),
      do: raise(ArgumentError, "unsafe build link: #{relative}")
  end

  @doc "Records actual runtime/tool versions and executable digests, not just requested pins."
  @spec toolchain() :: map()
  def toolchain do
    %{
      "elixir" => System.version(),
      "otp" =>
        String.trim(
          File.read!(
            Path.join([:code.root_dir(), "releases", System.otp_release(), "OTP_VERSION"])
          )
        ),
      "erts" => List.to_string(:erlang.system_info(:version)),
      "architecture" => List.to_string(:erlang.system_info(:system_architecture)),
      "tools" =>
        Map.new(~w(elixir erl lean lake bwrap git), fn tool ->
          path = System.find_executable(tool)

          {version, 0} =
            System.cmd(
              path,
              if(tool == "erl",
                do: [
                  "-noshell",
                  "-eval",
                  "io:format(\"~p~n\", [erlang:system_info(version)]), halt()."
                ],
                else: ["--version"]
              ),
              stderr_to_stdout: true
            )

          {tool,
           %{
             "path" => path,
             "sha256" => Manifest.digest(File.read!(path)),
             "version" => String.trim(version)
           }}
        end)
    }
  end

  defp write(output, name, bytes) do
    true = Manifest.safe_name?(name)
    path = Path.join(output, name)
    File.mkdir_p!(Path.dirname(path))
    File.write!(path, bytes)
  end
end
