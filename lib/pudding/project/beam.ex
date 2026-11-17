defmodule Pudding.Project.Beam do
  @moduledoc """
  Non-executing BEAM preflight and code-path binding. Debug reconstruction is a
  separate operation, called only after the complete code-path preflight succeeds.
  The allowlist is deliberately limited to the pinned Elixir/OTP backends.
  """
  alias Pudding.Project.Manifest

  @backends [:elixir_erl, :erl_abstract_code]

  @doc "Inspects raw chunks without dispatching any debug-info callback."
  @spec preflight(bytes :: binary()) :: {:ok, map()} | {:error, term()}
  def preflight(bytes) do
    with {:ok, module, chunks} <- :beam_lib.all_chunks(bytes),
         :ok <- unique_chunks(chunks),
         {:ok, {^module, [debug_info: {:debug_info_v1, backend, data}, compile_info: info]}} <-
           :beam_lib.chunks(bytes, [:debug_info, :compile_info]),
         true <- backend in @backends,
         true <- is_list(info),
         :ok <- safe_debug(backend, data) do
      {:ok,
       %{
         module: module,
         backend: backend,
         data: data,
         compile_info: info,
         chunks: Map.new(chunks),
         sha256: Manifest.digest(bytes)
       }}
    else
      false -> {:error, :unapproved_debug_backend_or_compile_info}
      {:ok, {_module, _chunks}} -> {:error, :missing_or_malformed_debug_info}
      {:error, _, reason} -> {:error, {:malformed_beam, reason}}
      {:error, :duplicate_beam_chunks} = error -> error
      other -> {:error, {:invalid_debug_info, other}}
    end
  rescue
    error -> {:error, {:malformed_beam, Exception.message(error)}}
  end

  defp unique_chunks(chunks) do
    # beam_lib's decoded lookup selects the first chunk, while Map.new selects
    # the last. Reject ambiguity before decoding or retaining either view.
    if map_size(Map.new(chunks)) == length(chunks),
      do: :ok,
      else: {:error, :duplicate_beam_chunks}
  end

  @doc "Reconstructs Core using an already-preflighted, explicitly allowed backend."
  @spec reconstruct(preflight :: map()) :: {:ok, term()} | {:error, term()}
  def reconstruct(%{backend: backend, module: module, data: data}) when backend in @backends do
    with :ok <- safe_debug(backend, data) do
      case backend.debug_info(:core_v1, module, data, []) do
        {:ok, core} -> {:ok, core}
        {:error, reason} -> {:error, {:unsupported_reconstruction, reason}}
        _ -> {:error, :malformed_reconstruction}
      end
    end
  rescue
    error -> {:error, {:reconstruction_error, Exception.message(error)}}
  end

  def reconstruct(_preflight), do: {:error, :unapproved_debug_backend}

  # Reconstruction recompiles embedded forms. An allowed backend alone is not
  # sufficient: compiler transforms can dispatch further callbacks. Unknown
  # options remain unsupported rather than being silently removed.
  defp safe_debug(:elixir_erl, {:elixir_v1, %{compile_opts: opts, attributes: attributes}, specs})
       when is_list(specs) and is_list(attributes) do
    safe_compilation(opts, attributes ++ specs)
  end

  defp safe_debug(:erl_abstract_code, {forms, opts}) when is_list(forms),
    do: safe_compilation(opts, forms)

  defp safe_debug(_, _), do: {:error, :unsupported_debug_data}

  defp safe_compilation(options, forms) do
    if safe_options?(options) and safe_directives?(forms),
      do: :ok,
      else: {:error, :unsupported_compiler_directive}
  end

  defp safe_options?(options) when is_list(options), do: Enum.all?(options, &safe_option?/1)
  defp safe_options?(_), do: false

  defp safe_option?(option) when is_atom(option) do
    option in ~w(debug_info no_debug_info deterministic no_auto_import inline
      warn_missing_doc_function warn_missing_doc_callback warn_missing_spec_documented
      warn_deprecated_catch warn_obsolete_bool_op nowarn_unused_function
      nowarn_unused_vars nowarn_shadow_vars warn_export_all warn_unused_import
      warn_unused_vars warn_unused_function warn_bif_clash warnings_as_errors)a
  end

  defp safe_option?({key, path}) when key in [:cwd, :i, :source],
    do: is_list(path) and Enum.all?(path, &is_integer/1)

  defp safe_option?({key, functions}) when key in [:inline, :no_auto_import],
    do:
      is_list(functions) and
        Enum.all?(functions, &match?({name, arity} when is_atom(name) and is_integer(arity), &1))

  defp safe_option?(_), do: false

  defp safe_directives?({:attribute, _, :compile, options}),
    do: safe_options?(List.wrap(options))

  defp safe_directives?({:compile, options}), do: safe_options?(List.wrap(options))

  defp safe_directives?(term) when is_tuple(term),
    do: term |> Tuple.to_list() |> Enum.all?(&safe_directives?/1)

  defp safe_directives?(term) when is_list(term), do: Enum.all?(term, &safe_directives?/1)

  defp safe_directives?(term) when is_map(term),
    do: term |> Map.to_list() |> Enum.all?(&safe_directives?/1)

  defp safe_directives?(_term), do: true

  @doc "Rejects ambiguous modules even if two candidates happen to have identical bytes."
  @spec index(candidates :: [map()]) :: {:ok, map()} | {:error, term()}
  def index(candidates) do
    Enum.reduce_while(candidates, {:ok, %{}}, fn candidate, {:ok, index} ->
      module = candidate["module"]

      if Map.has_key?(index, module),
        do: {:halt, {:error, {:ambiguous_module, module}}},
        else: {:cont, {:ok, Map.put(index, module, candidate)}}
    end)
  end

  @doc """
  Checks the selected file's exact bytes and the currently loaded executable identity.

  OTP's loaded-code MD5 is compared using its runtime BIF, not a consumer
  module_info callback. It binds executable code, not raw debug chunks; the file
  SHA-256 binds the full artifact. This is a check in a controlled VM, not an
  attestation against a concurrent hostile code loader or an MD5 collision.
  """
  @spec selected(module :: module(), expected :: map()) :: :ok | {:error, term()}
  def selected(module, expected) do
    with path when is_list(path) <- :code.which(module),
         true <- List.to_string(path) == expected["path"],
         {:ok, bytes} <- File.read(path),
         true <- Manifest.digest(bytes) == expected["sha256"],
         {:ok, {^module, md5}} <- :beam_lib.md5(bytes),
         true <- :erlang.module_loaded(module),
         true <- :erlang.get_module_info(module, :md5) == md5 do
      :ok
    else
      _ -> {:error, {:module_substitution, Atom.to_string(module)}}
    end
  rescue
    ArgumentError -> {:error, {:module_substitution, Atom.to_string(module)}}
  end
end
