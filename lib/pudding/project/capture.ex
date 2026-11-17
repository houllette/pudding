defmodule Pudding.Project.Capture do
  @moduledoc """
  Two-clean-build capture for declaratively authorized ordinary Mix consumers.

  Consumer code runs only in offline, bounded Linux containers. A build's entire
  process namespace is destroyed before a separate trusted inspector reads its
  output volume read-only. The consumer never sees the bundle store, orchestration
  scripts, or the inspector's tool build. Identity changes always require a fresh
  capture; there is no proof cache and no `proved` result from this API.
  """
  alias Pudding.Execution.Container
  alias Pudding.Project.Inputs
  alias Pudding.Project.Manifest

  @lynx "99a6db764c154207cf3b28c35409d9b56c463357"

  @doc "Captures twice into a new output directory. Requires a digest-pinned qualified image."
  @spec run(request :: map(), output :: Path.t(), options :: keyword()) ::
          {:ok, map()} | {:error, term()}
  def run(request, output, options) do
    with :ok <- Inputs.validate(request),
         :ok <- Inputs.destination_safe(request, output),
         {:ok, image} <- image_identity(options[:image]),
         :ok <- new_output(output) do
      execute(request, Path.expand(output), image, options)
    end
  rescue
    error -> {:error, {:capture_error, Exception.message(error)}}
  end

  defp new_output(output) do
    if File.exists?(output), do: {:error, :already_exists}, else: File.mkdir_p(output)
  end

  defp image_identity("sha256:" <> hash = image) when byte_size(hash) == 64 do
    with {:ok, output} <-
           Container.command([
             "image",
             "inspect",
             "--format",
             "{{.Id}} {{.Os}}/{{.Architecture}}",
             image
           ]),
         [^image, "linux/arm64"] <- String.split(output) do
      {:ok, image}
    else
      error -> {:error, {:unsupported_image, error}}
    end
  end

  defp image_identity(_image), do: {:error, :image_digest_required}

  defp execute(request, output, image, options) do
    limits = Map.merge(Container.limits(), Map.new(Keyword.get(options, :limits, [])))
    token = Base.encode16(:crypto.strong_rand_bytes(12), case: :lower)
    stage = Path.join(output, "staging")
    tree = Path.join(stage, "tree")
    tool = Path.join(stage, "tool")
    tools_volume = "pudding-tools-" <> token
    volumes = for n <- 1..2, do: "pudding-build-#{token}-#{n}"
    exports = Enum.map(volumes, &(&1 <> "-export"))
    # Tools are authorized separately, never compiled from consumer-written BEAMs.
    trusted_root = Keyword.fetch!(options, :trusted_root) |> Path.expand()
    lynx = Keyword.fetch!(options, :lynx_source) |> Path.expand()

    try do
      with {:ok, inventory} <- Inputs.stage(request, tree),
           :ok <- stage_tools(trusted_root, lynx, tool),
           :ok <- write_request(stage, request),
           {:ok, inputs} <- seal_inputs(output, tree, inventory, request, image, tool, limits),
           :ok <- volume(tools_volume, "3g"),
           :ok <- prepare_build_volumes(volumes, limits["workspace"]),
           :ok <- prepare_build_volumes(exports, "256m"),
           {:ok, _} <- hold_volumes(image, [tools_volume | volumes ++ exports], token, limits),
           {:ok, _} <-
             run_worker(
               image,
               stage,
               tools_volume,
               nil,
               "tools",
               token <> "-tools",
               limits,
               output
             ),
           {:ok, first} <-
             build_and_inspect(
               1,
               Enum.at(volumes, 0),
               tools_volume,
               token,
               image,
               stage,
               output,
               limits
             ),
           {:ok, second} <-
             build_and_inspect(
               2,
               Enum.at(volumes, 1),
               tools_volume,
               token,
               image,
               stage,
               output,
               limits
             ) do
        comparison = compare(first, second)

        summary = %{
          "schema_version" => 1,
          "inputs" => inputs["id"],
          "builds" => [first["id"], second["id"]],
          "comparison" => comparison,
          "status" => if(comparison["equal"], do: "captured", else: "nondeterministic"),
          "closure_gate" => "blocked_supported_lynx_api_required",
          "phase_04_gate" => "blocked",
          "assurance" => "captured_not_proved",
          "proof_reuse" => "forbidden",
          "unknown_inputs" => request["unknown_inputs"],
          "image" => image
        }

        File.write!(Path.join(output, "capture.json"), Manifest.canonical(summary))
        {:ok, summary}
      end
    after
      for name <- [
            token <> "-holder",
            token <> "-tools",
            token <> "-build-1",
            token <> "-build-2",
            token <> "-inspect-1",
            token <> "-inspect-2"
          ] do
        Container.command(["rm", "--force", "pudding-" <> name])
      end

      for name <- [tools_volume | volumes ++ exports],
          do: Container.command(["volume", "rm", "--force", name])

      # Staging is not evidence. Only sealed inputs/artifacts and bounded logs survive.
      File.rm_rf(stage)
    end
  end

  defp stage_tools(root, lynx, tool) do
    {:ok, revision} =
      Container.command(["-C", lynx, "rev-parse", "HEAD"], engine: "git", timeout_ms: 60_000)

    {:ok, dirty} =
      Container.command(["-C", lynx, "status", "--porcelain", "--untracked-files=all"],
        engine: "git",
        timeout_ms: 60_000
      )

    if String.trim(revision) == @lynx and dirty == "" do
      File.mkdir_p!(tool)

      {:ok, _} =
        Inputs.stage(
          %{
            "root" => lynx,
            "project" => "Lean",
            "inputs" => ~w(lib src Lean mix.exs lean-toolchain),
            "dependencies" => [],
            "writable_paths" => [],
            "environment" => %{"MIX_ENV" => "prod", "MIX_TARGET" => "host"},
            "roots" => [%{"module" => "Lynx", "function" => "module_info", "arity" => 0}],
            "laws" => [],
            "unknown_inputs" => []
          },
          Path.join(tool, "lynx")
        )

      File.mkdir_p!(Path.join(tool, "pudding/lib"))

      for dir <- ~w(project execution) do
        File.cp_r!(Path.join([root, "lib/pudding", dir]), Path.join([tool, "pudding/lib", dir]))
      end

      File.cp_r!(Path.join(root, "priv/capture"), Path.join(tool, "driver"))
      :ok
    else
      {:error, :untrusted_lynx_identity}
    end
  end

  defp write_request(stage, request) do
    # Remove host paths, which are never consumer-visible environment/configuration.
    guest =
      Map.delete(request, "root")
      |> Map.update!("dependencies", fn deps -> Enum.map(deps, &Map.delete(&1, "source")) end)

    File.write!(Path.join(stage, "request.json"), Manifest.canonical(guest))
    :ok
  end

  defp seal_inputs(output, tree, inventory, request, image, tool, limits) do
    sources =
      Map.new(inventory, fn {name, entry} ->
        bytes = if entry["type"] == "regular", do: File.read!(Path.join(tree, name)), else: ""
        {"source/" <> name, bytes}
      end)

    tool_inventory = Inputs.inventory(tool)

    tools =
      Map.new(tool_inventory, fn {name, entry} ->
        bytes = if entry["type"] == "regular", do: File.read!(Path.join(tool, name)), else: ""
        {"tool/" <> name, bytes}
      end)

    metadata = %{
      "request" => Map.drop(request, ["root"]),
      "inventory" => inventory,
      "tool_inventory" => tool_inventory,
      "image" => image,
      "lynx_revision" => @lynx,
      "limits" => limits,
      "normalizations" => [],
      "identity_policy" => "exact_bytes_no_cross_build_reuse"
    }

    Manifest.seal(Path.join(output, "inputs"), metadata, Map.merge(sources, tools))
  end

  defp volume(name, size) do
    case Container.command([
           "volume",
           "create",
           "--driver",
           "local",
           "--opt",
           "type=tmpfs",
           "--opt",
           "device=tmpfs",
           "--opt",
           "o=size=#{size},uid=1000,gid=1000,mode=0700",
           name
         ]) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  # Local-driver tmpfs is otherwise unmounted (and emptied) between worker containers.
  # A trusted, read-only holder keeps these bounded mounts alive through both builds.
  defp hold_volumes(image, volumes, token, limits) do
    mounts =
      volumes
      |> Enum.with_index()
      |> Enum.flat_map(fn {volume, n} ->
        ["--mount", "type=volume,src=#{volume},dst=/hold-#{n},readonly"]
      end)

    Container.command(
      Container.isolation("pudding-" <> token <> "-holder", limits) ++
        ["--detach", "--user", "1000:1000"] ++ mounts ++ [image, "sleep", "infinity"]
    )
  end

  defp prepare_build_volumes(volumes, size) do
    Enum.reduce_while(volumes, :ok, fn name, :ok ->
      case volume(name, size) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp build_and_inspect(n, volume_name, tools_volume, token, image, stage, output, limits) do
    with {:ok, _} <-
           run_worker(
             image,
             stage,
             tools_volume,
             volume_name,
             "build",
             "#{token}-build-#{n}",
             limits,
             output
           ),
         {:ok, _} <-
           run_worker(
             image,
             stage,
             tools_volume,
             volume_name,
             "inspect",
             "#{token}-inspect-#{n}",
             limits,
             output
           ) do
      export_bundle(n, token, output, limits)
    end
  end

  defp export_bundle(n, token, output, limits) do
    with {:ok, bytes} <-
           Container.command(["cp", "pudding-#{token}-holder:/hold-#{n + 2}/export.json", "-"],
             output_bytes: limits["artifact_bytes"],
             timeout_ms: 120_000
           ),
         {:ok, [{_name, payload}]} <- :erl_tar.extract({:binary, bytes}, [:memory]),
         {:ok, objects} <- JSON.decode(payload) do
      files = Map.new(objects, fn {name, encoded} -> {name, Base.decode64!(encoded)} end)
      metadata = JSON.decode!(Map.fetch!(files, "inspection.json"))
      Manifest.seal(Path.join(output, "build-#{n}"), metadata, files)
    end
  end

  defp run_worker(image, stage, tools_volume, build_volume, mode, suffix, limits, output) do
    name = "pudding-" <> suffix

    mounts = [
      "--mount",
      "type=bind,src=#{stage}/tool,dst=/trusted,readonly",
      "--mount",
      "type=bind,src=#{stage}/request.json,dst=/request.json,readonly",
      "--mount",
      "type=volume,src=#{tools_volume},dst=/tool#{if(mode == "tools", do: "", else: ",readonly")}"
    ]

    mounts =
      if build_volume,
        do:
          mounts ++
            [
              "--mount",
              "type=volume,src=#{build_volume},dst=/work#{if(mode == "inspect", do: ",readonly", else: "")}",
              "--mount",
              "type=bind,src=#{stage}/tree,dst=/workspace,readonly"
            ],
        else: mounts

    mounts =
      if mode == "inspect",
        do: mounts ++ ["--mount", "type=volume,src=#{build_volume}-export,dst=/export"],
        else: mounts

    args =
      Container.isolation(name, limits) ++
        ["--user", "1000:1000"] ++
        mounts ++
        [image, "sh", "/trusted/driver/worker.sh", mode]

    started = System.monotonic_time(:millisecond)

    result =
      Container.command(args,
        container: name,
        timeout_ms: limits["wall_ms"],
        output_bytes: limits["output_bytes"]
      )

    log =
      case result do
        {:ok, bytes} -> bytes
        {:error, error} -> error.output
      end

    File.write!(Path.join(output, suffix <> ".log"), log)

    metrics = execution_metrics(name)

    File.write!(
      Path.join(output, suffix <> ".execution.json"),
      Manifest.canonical(%{
        "elapsed_ms" => System.monotonic_time(:millisecond) - started,
        "result" => inspect(elem(result, 0)),
        "engine_inspection" => metrics
      })
    )

    # A successful build container must also be destroyed before inspection.
    if mode == "build" do
      with {:ok, _} <- Container.command(["rm", "--force", name]), do: result
    else
      result
    end
  end

  defp execution_metrics(name) do
    case Container.command(["inspect", "--format", "{{json .State}} {{json .HostConfig}}", name]) do
      {:ok, bytes} -> bytes
      {:error, error} -> "inspection_failed: " <> inspect(error)
    end
  end

  @doc "Compares exact artifact inventories from two clean builds, without normalization."
  @spec compare(first :: map(), second :: map()) :: map()
  def compare(first, second) do
    a = first["files"]
    b = second["files"]

    changed =
      (Map.keys(a) ++ Map.keys(b)) |> Enum.uniq() |> Enum.filter(&(a[&1] != b[&1])) |> Enum.sort()

    %{
      "equal" => changed == [],
      "changed" => changed,
      "normalizations" => [],
      "classification" =>
        if(changed == [],
          do: "two_clean_builds_byte_equal",
          else: "nondeterministic_or_undeclared_input"
        ),
      "scope" => "two_runs_only_not_universal_determinism"
    }
  end
end
