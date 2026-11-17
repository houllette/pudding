defmodule Pudding.Project.Manifest do
  @moduledoc """
  Content-addressed capture bundles, schema 1. Hashes bind bytes, not semantics.

  `seal/3` creates a new bundle only. Objects are read-only and every read verifies
  their contents. Owners can still change filesystem permissions; retain the bundle
  ID in a separately trusted location. Neither this format nor capture issues proof
  receipts, permits cross-build evidence reuse, or authenticates debug information.
  """

  @doc "SHA-256 of exact bytes, lowercase hexadecimal."
  @spec digest(bytes :: iodata()) :: String.t()
  def digest(bytes), do: :crypto.hash(:sha256, bytes) |> Base.encode16(case: :lower)

  @doc "Canonical JSON encoding with sorted map keys and no semantic normalization."
  @spec canonical(value :: term()) :: binary()
  def canonical(value) when is_map(value) do
    entries =
      value |> Enum.sort() |> Enum.map(fn {k, v} -> [JSON.encode!(k), ":", canonical(v)] end)

    IO.iodata_to_binary(["{", Enum.intersperse(entries, ","), "}"])
  end

  def canonical(value) when is_list(value),
    do: IO.iodata_to_binary(["[", Enum.intersperse(Enum.map(value, &canonical/1), ","), "]"])

  def canonical(value), do: JSON.encode!(value)

  @doc "Creates a new immutable bundle from named exact bytes and JSON metadata."
  @spec seal(directory :: Path.t(), metadata :: map(), files :: %{String.t() => binary()}) ::
          {:ok, map()} | {:error, term()}
  def seal(directory, metadata, files) do
    cond do
      File.exists?(directory) -> {:error, :already_exists}
      not Enum.all?(Map.keys(files), &safe_name?/1) -> {:error, :unsafe_name}
      true -> create(directory, metadata, files)
    end
  end

  defp create(directory, metadata, files) do
    with :ok <- File.mkdir_p(Path.dirname(directory)),
         :ok <- File.mkdir(directory) do
      File.mkdir!(Path.join(directory, "objects"))
      create_objects(directory, metadata, files)
    end
  end

  defp create_objects(directory, metadata, files) do
    objects =
      Map.new(files, fn {name, bytes} ->
        hash = digest(bytes)
        path = Path.join([directory, "objects", hash])

        unless File.exists?(path) do
          File.write!(path, bytes, [:exclusive])
          File.chmod!(path, 0o444)
        end

        {name, %{"sha256" => hash, "size" => byte_size(bytes)}}
      end)

    body = %{"schema_version" => 1, "metadata" => metadata, "files" => objects}
    manifest = Map.put(body, "id", digest(canonical(body)))
    File.write!(Path.join(directory, "manifest.json"), canonical(manifest))
    File.chmod!(Path.join(directory, "manifest.json"), 0o444)
    {:ok, manifest}
  end

  @doc "Loads a bundle, checking schema, identity, names, lengths and all object digests."
  @spec load(directory :: Path.t()) :: {:ok, map()} | {:error, term()}
  def load(directory) do
    with :ok <- safe_layout(directory),
         {:ok, bytes} <- File.read(Path.join(directory, "manifest.json")),
         {:ok, manifest} <- JSON.decode(bytes),
         :ok <- validate(manifest),
         :ok <- check_objects(directory, manifest["files"]),
         :ok <- exact_entries(directory, manifest["files"]) do
      {:ok, manifest}
    end
  end

  @doc "Like load/1 but raises for invalid bundles."
  @spec load!(directory :: Path.t()) :: map()
  def load!(directory) do
    case load(directory) do
      {:ok, manifest} -> manifest
      {:error, reason} -> raise ArgumentError, "invalid capture bundle: #{inspect(reason)}"
    end
  end

  @doc "Reads a named object, verifying the whole bundle before returning its bytes."
  @spec read(directory :: Path.t(), name :: String.t()) :: {:ok, binary()} | {:error, term()}
  def read(directory, name) do
    with {:ok, manifest} <- load(directory),
         {:ok, object} <- Map.fetch(manifest["files"], name),
         {:ok, %{type: :regular}} <-
           File.lstat(Path.join([directory, "objects", object["sha256"]])),
         {:ok, bytes} <- File.read(Path.join([directory, "objects", object["sha256"]])),
         true <- byte_size(bytes) == object["size"] and digest(bytes) == object["sha256"] do
      {:ok, bytes}
    else
      false -> {:error, :object_changed}
      :error -> {:error, :missing_object}
      error -> error
    end
  end

  @doc "Checks a portable bundle-relative name; absolute paths and traversal are rejected."
  @spec safe_name?(name :: term()) :: boolean()
  def safe_name?(name) when is_binary(name) do
    name != "" and Path.type(name) == :relative and
      not String.contains?(name, ["\\", "\u0000"]) and
      Enum.all?(String.split(name, "/"), &(&1 not in ["", ".", ".."]))
  end

  def safe_name?(_name), do: false

  defp validate(
         %{"schema_version" => 1, "files" => files, "metadata" => metadata, "id" => id} = m
       )
       when map_size(m) == 4 and is_map(files) and is_map(metadata) do
    if id == digest(canonical(Map.delete(m, "id"))) and Enum.all?(Map.keys(files), &safe_name?/1),
      do: :ok,
      else: {:error, :manifest_mismatch}
  end

  defp validate(_manifest), do: {:error, :invalid_manifest}

  defp safe_layout(directory) do
    expected = [
      {directory, :directory},
      {Path.join(directory, "objects"), :directory},
      {Path.join(directory, "manifest.json"), :regular}
    ]

    if Enum.all?(expected, fn {path, type} ->
         match?({:ok, %{type: ^type}}, File.lstat(path))
       end), do: :ok, else: {:error, :unsafe_bundle}
  end

  defp exact_entries(directory, files) do
    expected = files |> Map.values() |> Enum.map(& &1["sha256"]) |> Enum.uniq() |> Enum.sort()

    with {:ok, root} <- File.ls(directory),
         {:ok, objects} <- File.ls(Path.join(directory, "objects")),
         true <- Enum.sort(root) == ["manifest.json", "objects"],
         true <- Enum.sort(objects) == expected do
      :ok
    else
      _ -> {:error, :unexpected_entries}
    end
  end

  defp check_objects(directory, files) do
    Enum.reduce_while(files, :ok, fn {name, object}, :ok ->
      if valid_object?(directory, object),
        do: {:cont, :ok},
        else: {:halt, {:error, {:object_mismatch, name}}}
    end)
  end

  defp valid_object?(directory, %{"sha256" => hash, "size" => size} = object)
       when map_size(object) == 2 and is_binary(hash) and is_integer(size) and size >= 0 do
    with true <- Regex.match?(~r/\A[0-9a-f]{64}\z/, hash),
         {:ok, %{type: :regular, size: ^size}} <-
           File.lstat(Path.join([directory, "objects", hash])),
         {:ok, actual} <- hash_file(Path.join([directory, "objects", hash])) do
      actual == hash
    else
      _ -> false
    end
  end

  defp valid_object?(_directory, _object), do: false

  defp hash_file(path) do
    case File.open(path, [:read, :binary]) do
      {:ok, file} ->
        try do
          hash_chunks(file, :crypto.hash_init(:sha256))
        after
          File.close(file)
        end

      error ->
        error
    end
  end

  defp hash_chunks(file, context) do
    case IO.binread(file, 65_536) do
      :eof -> {:ok, context |> :crypto.hash_final() |> Base.encode16(case: :lower)}
      {:error, reason} -> {:error, reason}
      bytes -> hash_chunks(file, :crypto.hash_update(context, bytes))
    end
  end
end
