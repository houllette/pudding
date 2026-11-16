defmodule ArchivePath.Fixed do
  @moduledoc """
  Byte-recursive validator for the synthetic fixture, not an extraction API.
  All finite binaries are in the binary domain; every other BEAM term, including
  nonbyte-aligned bitstrings, belongs to the separate nonbinary wrapper domain.
  """

  @doc "Validates without decoding or rewriting any accepted byte."
  @spec validate(input :: term()) ::
          {:ok, [binary()]} | {:error, :invalid_path | :not_binary}
  def validate(input) when is_binary(input), do: scan(input, <<>>, [])
  def validate(_input), do: {:error, :not_binary}

  defp scan(<<>>, component, components), do: finish(component, components)
  defp scan(<<0, _rest::binary>>, _component, _components), do: {:error, :invalid_path}

  defp scan(<<47, rest::binary>>, component, components) do
    if component in [<<>>, ".", ".."],
      do: {:error, :invalid_path},
      else: scan(rest, <<>>, [component | components])
  end

  defp scan(<<byte, rest::binary>>, component, components),
    do: scan(rest, <<component::binary, byte>>, components)

  defp finish(component, components) do
    if component in [<<>>, ".", ".."],
      do: {:error, :invalid_path},
      else: {:ok, :lists.reverse([component | components])}
  end
end
