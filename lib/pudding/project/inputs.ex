defmodule Pudding.Project.Inputs do
  @moduledoc """
  Declarative input staging. Never evaluates consumer Mix files on the host.

  The caller authorizes source roots and already-fetched dependency directories.
  Every file below those roots is included except SCM/build/cache directories.
  Symlinks, devices, sockets, overlapping mounts and inputs outside authorized
  roots fail closed. Git dependencies retain a minimal local clone for Mix's lock
  checks; fetching and credentials stay outside the offline execution boundary.
  """
  alias Pudding.Project.Manifest

  @excluded ~w(.git _build deps .lake .elixir_ls .lexical node_modules tmp doc)

  @doc "Stages explicitly authorized inputs into a new directory and returns their inventory."
  @spec stage(request :: map(), destination :: Path.t()) :: {:ok, map()} | {:error, term()}
  def stage(request, destination) do
    with :ok <- validate(request),
         :ok <- destination_safe(request, destination),
         :ok <- safe_sources(request),
         :ok <- check_budget(request),
         false <- File.exists?(destination),
         :ok <- File.mkdir_p(destination),
         :ok <- copy_root(request["root"], destination, request["inputs"]),
         :ok <- dependencies(request["dependencies"], destination),
         :ok <- placeholders(request, destination),
         inventory = inventory(destination),
         :ok <- referenced_inputs(request, inventory) do
      {:ok, inventory}
    else
      true -> {:error, :already_exists}
      error -> error
    end
  end

  @doc "Rejects staging/output overlap with any authorized source tree before writing."
  @spec destination_safe(request :: map(), destination :: Path.t()) :: :ok | {:error, term()}
  def destination_safe(request, destination) do
    destination = Path.expand(destination)

    sources =
      Enum.map(request["inputs"], &Path.expand(&1, request["root"])) ++
        Enum.map(request["dependencies"], &Path.expand(&1["source"]))

    with :ok <- safe_destination(destination) do
      if Enum.any?(sources, &(inside?(destination, &1) or inside?(&1, destination))),
        do: {:error, :output_overlaps_input},
        else: :ok
    end
  end

  defp safe_destination(path) do
    case File.lstat(path) do
      {:ok, %{type: :symlink}} -> {:error, :symlink_output_ancestor}
      {:error, reason} when reason != :enoent -> {:error, {:output_error, reason}}
      _ when path == "/" -> :ok
      _ -> safe_destination(Path.dirname(path))
    end
  end

  defp inside?(path, parent), do: path == parent or String.starts_with?(path, parent <> "/")

  defp safe_sources(request) do
    sources =
      Enum.map(request["inputs"], &Path.expand(&1, request["root"])) ++
        Enum.map(request["dependencies"], &Path.expand(&1["source"]))

    Enum.reduce_while(sources, :ok, fn source, :ok ->
      case safe_components("/", String.trim_leading(source, "/")) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp referenced_inputs(request, inventory) do
    references = Map.get(request, "accepted_inputs", []) ++ List.wrap(request["proof_postlude"])

    case Enum.find(references, &(get_in(inventory, [&1, "type"]) != "regular")) do
      nil -> :ok
      name -> {:error, {:missing_referenced_input, name}}
    end
  end

  # These host-side limits precede copying/reading; guest cgroups cannot bound staging.
  # The source trees must remain quiescent while capture runs (no snapshot claim).
  defp check_budget(request) do
    sources =
      Enum.map(request["inputs"], &{Path.join(request["root"], &1), @excluded}) ++
        Enum.map(
          request["dependencies"],
          &{&1["source"], if(&1["kind"] == "git", do: @excluded -- ["deps"], else: @excluded)}
        ) ++
        (request["dependencies"]
         |> Enum.filter(&(&1["kind"] == "git"))
         |> Enum.map(&{Path.join(&1["source"], ".git"), []}))

    Enum.reduce_while(sources, {:ok, {0, 0}}, fn {path, excluded}, {:ok, budget} ->
      case budget(path, budget, 0, excluded) do
        {:ok, next} -> {:cont, {:ok, next}}
        error -> {:halt, error}
      end
    end)
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end

  defp budget(_path, _budget, depth, _excluded) when depth > 64, do: {:error, :input_depth_limit}

  defp budget(path, {bytes, count}, depth, excluded) do
    case File.lstat(path) do
      {:ok, %{type: :regular, size: size}} when bytes + size <= 134_217_728 and count < 20_000 ->
        {:ok, {bytes + size, count + 1}}

      {:ok, %{type: :directory}} when count < 20_000 ->
        directory_budget(path, {bytes, count + 1}, depth + 1, excluded)

      {:ok, %{type: type}} when type not in [:regular, :directory] ->
        {:error, {:unsafe_input, path, type}}

      {:ok, _} ->
        {:error, :input_size_or_count_limit}

      {:error, reason} ->
        {:error, {:input_error, path, reason}}
    end
  end

  defp directory_budget(path, acc, depth, excluded) do
    path
    |> File.ls!()
    |> Enum.reject(&(&1 in excluded))
    |> Enum.reduce_while({:ok, acc}, fn name, {:ok, acc} ->
      case budget(Path.join(path, name), acc, depth, excluded) do
        {:ok, next} -> {:cont, {:ok, next}}
        error -> {:halt, error}
      end
    end)
  end

  @doc "Inventories bytes, permission bits and directories; rejects links and special files."
  @spec inventory(directory :: Path.t()) :: map()
  def inventory(directory) do
    directory
    |> walk("")
    |> Map.new(fn {name, path, type, mode} ->
      bytes = if type == :regular, do: File.read!(path), else: ""

      {name,
       %{
         "type" => Atom.to_string(type),
         "mode" => Bitwise.band(mode, 0o777),
         "sha256" => Manifest.digest(bytes),
         "size" => byte_size(bytes),
         "executable" => Bitwise.band(mode, 0o111) != 0
       }}
    end)
  end

  @doc "Validates the closed request schema before consumer code can run."
  @spec validate(request :: term()) :: :ok | {:error, term()}
  def validate(request) when is_map(request) do
    required =
      ~w(root project inputs dependencies writable_paths environment roots laws unknown_inputs)

    optional = ~w(compiler_args proof_postlude accepted_inputs)

    checks = [
      Enum.all?(required, &Map.has_key?(request, &1)),
      Enum.all?(Map.keys(request), &(&1 in (required ++ optional))),
      valid_source?(request),
      valid_lists?(request),
      valid_environment?(request["environment"]),
      valid_proof?(request)
    ]

    if Enum.all?(checks) do
      with :ok <- validate_layout(request), do: validate_mounts(request)
    else
      {:error, :invalid_request}
    end
  end

  def validate(_request), do: {:error, :invalid_request}

  defp valid_source?(request) do
    is_binary(request["root"]) and File.dir?(request["root"]) and
      Manifest.safe_name?(request["project"]) and request["inputs"] != [] and
      valid_list?(request["inputs"], &Manifest.safe_name?/1)
  end

  defp valid_lists?(request) do
    checks = [
      valid_list?(request["dependencies"], &valid_dependency?/1),
      valid_list?(request["writable_paths"], &Manifest.safe_name?/1),
      request["roots"] != [],
      valid_list?(request["roots"], &valid_root?/1),
      strings?(request["laws"]),
      strings?(request["unknown_inputs"]),
      strings?(Map.get(request, "compiler_args", [])),
      valid_list?(Map.get(request, "accepted_inputs", []), &Manifest.safe_name?/1)
    ]

    Enum.all?(checks)
  end

  defp valid_list?(values, predicate), do: is_list(values) and Enum.all?(values, predicate)

  defp valid_proof?(request) do
    not Map.has_key?(request, "proof_postlude") or Manifest.safe_name?(request["proof_postlude"])
  end

  defp valid_environment?(env) when is_map(env) do
    Map.keys(env) |> Enum.sort() == ~w(MIX_ENV MIX_TARGET) and
      Enum.all?(Map.values(env), &(is_binary(&1) and Regex.match?(~r/\A[a-z][a-z0-9_]*\z/, &1)))
  end

  defp valid_environment?(_env), do: false
  defp strings?(values), do: is_list(values) and Enum.all?(values, &is_binary/1)

  defp valid_root?(%{"module" => module, "function" => function, "arity" => arity} = root)
       when map_size(root) == 3,
       do:
         is_binary(module) and byte_size(module) in 1..255 and is_binary(function) and
           byte_size(function) in 1..255 and is_integer(arity) and arity in 0..255

  defp valid_root?(_root), do: false

  defp valid_dependency?(%{"destination" => dest, "source" => source, "kind" => "path"} = dep)
       when map_size(dep) == 3,
       do: Manifest.safe_name?(dest) and is_binary(source) and File.dir?(source)

  defp valid_dependency?(
         %{
           "destination" => dest,
           "source" => source,
           "kind" => "git",
           "revision" => revision,
           "url" => url
         } = dep
       )
       when map_size(dep) == 5,
       do:
         Manifest.safe_name?(dest) and is_binary(source) and File.dir?(source) and
           is_binary(url) and is_binary(revision) and Regex.match?(~r/\A[0-9a-f]{40}\z/, revision)

  defp valid_dependency?(_dep), do: false

  defp validate_layout(request) do
    paths = request["inputs"] ++ Enum.map(request["dependencies"], & &1["destination"])

    pairs =
      for {a, i} <- Enum.with_index(paths), {b, j} <- Enum.with_index(paths), i != j, do: {a, b}

    if Enum.any?(pairs, fn {a, b} -> a == b or String.starts_with?(a, b <> "/") end),
      do: {:error, :overlapping_inputs},
      else: :ok
  end

  defp validate_mounts(request) do
    destinations = Enum.map(request["dependencies"], & &1["destination"])
    mounts = [request["project"] <> "/_build" | request["writable_paths"]]
    pairs = for a <- mounts, b <- mounts, a != b, do: {a, b}

    if length(Enum.uniq(destinations)) == length(destinations) and
         length(Enum.uniq(mounts)) == length(mounts) and
         not Enum.any?(pairs, fn {a, b} -> String.starts_with?(a, b <> "/") end) and
         Enum.all?(
           mounts,
           &(String.ends_with?(&1, "/.lake") or String.ends_with?(&1, "/_build") or
               String.contains?(&1, "/generated/"))
         ),
       do: :ok,
       else: {:error, :unsafe_mounts}
  end

  defp copy_root(root, destination, inputs) do
    Enum.reduce_while(inputs, :ok, fn relative, :ok ->
      case copy_selected(root, destination, relative) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp copy_selected(root, destination, relative) do
    with :ok <- safe_components(Path.expand(root), relative),
         do: copy(Path.join(root, relative), Path.join(destination, relative))
  end

  defp copy(source, destination, excluded \\ @excluded) do
    case File.lstat(source) do
      {:ok, %{type: :regular, mode: mode}} ->
        File.mkdir_p!(Path.dirname(destination))
        File.cp!(source, destination)
        File.chmod!(destination, Bitwise.band(mode, 0o777))

      {:ok, %{type: :directory}} ->
        File.mkdir_p!(destination)

        copy_directory(source, destination, excluded)

      {:ok, %{type: type}} ->
        {:error, {:unsafe_input, source, type}}

      {:error, reason} ->
        {:error, {:input_error, source, reason}}
    end
  end

  defp safe_components(root, relative) do
    ["/" | parts] = Path.split(Path.join(root, relative))

    Enum.reduce_while(parts, "/", fn part, parent ->
      path = Path.join(parent, part)

      case File.lstat(path) do
        {:ok, %{type: :symlink}} -> {:halt, {:error, {:unsafe_input, path, :symlink}}}
        {:ok, _} -> {:cont, path}
        {:error, reason} -> {:halt, {:error, {:input_error, path, reason}}}
      end
    end)
    |> case do
      path when is_binary(path) -> :ok
      error -> error
    end
  end

  defp copy_directory(source, destination, excluded) do
    source
    |> File.ls!()
    |> Enum.reject(&(&1 in excluded))
    |> Enum.sort()
    |> Enum.reduce_while(:ok, fn name, :ok ->
      case copy(Path.join(source, name), Path.join(destination, name), excluded) do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp dependencies(deps, destination) do
    Enum.reduce_while(deps, :ok, fn dep, :ok ->
      target = Path.join(destination, dep["destination"])
      result = stage_dependency(dep, target)

      case result do
        :ok -> {:cont, :ok}
        error -> {:halt, error}
      end
    end)
  end

  defp stage_dependency(dep, target) do
    with :ok <- safe_components("/", String.trim_leading(Path.expand(dep["source"]), "/")) do
      if dep["kind"] == "git", do: clone(dep, target), else: copy(dep["source"], target)
    end
  end

  defp clone(dep, target) do
    # Host staging only copies bounded bytes. Git parses compressed objects only
    # inside the bounded offline build; stored-byte bounds do not bound expansion.
    source = dep["source"]
    forbidden = ~w(commondir objects/info/alternates objects/info/http-alternates info/grafts)

    config =
      "[core]\nrepositoryformatversion = 0\nbare = false\nhooksPath = /dev/null\n[remote \"origin\"]\nurl = \"" <>
        git_config_value(dep["url"]) <> "\"\n"

    with {:ok, %{type: :directory}} <- File.lstat(Path.join(source, ".git")),
         false <- Enum.any?(forbidden, &File.exists?(Path.join([source, ".git", &1]))),
         :ok <- copy(source, target, @excluded -- ["deps"]),
         {:ok, _} <- File.cp_r(Path.join(source, ".git"), Path.join(target, ".git")),
         :ok <- File.write(Path.join(target, ".git/config"), config) do
      :ok
    else
      error -> {:error, {:unsafe_git_dependency, dep["destination"], error}}
    end
  end

  defp git_config_value(value) do
    value
    |> String.replace("\\", "\\\\")
    |> String.replace("\"", "\\\"")
    |> String.replace("\n", "\\n")
    |> String.replace("\t", "\\t")
  end

  defp placeholders(request, destination) do
    for path <- [request["project"] <> "/_build" | request["writable_paths"]],
        do: File.mkdir_p!(Path.join(destination, path))

    :ok
  end

  defp walk(root, prefix) do
    root
    |> File.ls!()
    |> Enum.sort()
    |> Enum.flat_map(fn name ->
      path = Path.join(root, name)
      relative = if prefix == "", do: name, else: prefix <> "/" <> name

      case File.lstat!(path) do
        %{type: :regular, mode: mode} ->
          [{relative, path, :regular, mode}]

        %{type: :directory, mode: mode} ->
          [{relative, path, :directory, mode} | walk(path, relative)]

        %{type: type} ->
          raise ArgumentError, "unsafe staged input #{relative}: #{type}"
      end
    end)
  end
end
