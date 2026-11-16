defmodule Pudding.Contracts.PathPolicy do
  @moduledoc """
  Executable byte policy for the synthetic archive-path fixtures.

  Slash splitting preserves empty components. Every component must be nonempty,
  different from exact `.` and `..`, and free of NUL. No text decoding,
  normalization, filesystem interpretation, or safe extraction is implied.

  This reference splits first and checks complete components using binary
  matching; the fixed consumer instead scans bytes incrementally.
  Contract authority is recorded separately under `test/fixtures/contracts/`.
  """

  @type result :: {:ok, [binary()]} | {:error, :invalid_path | :not_binary}

  @doc "Returns the exact policy result, including `:not_binary` for every nonbinary term."
  @spec expected(input :: term()) :: result()
  def expected(input) when is_binary(input) do
    components = split_slash(input)

    if valid_components?(components),
      do: {:ok, components},
      else: {:error, :invalid_path}
  end

  def expected(_input), do: {:error, :not_binary}

  @doc "Splits a byte binary at slash, preserving all empty components."
  @spec split_slash(input :: binary()) :: [binary()]
  def split_slash(input) when is_binary(input), do: :binary.split(input, <<47>>, [:global])

  defp valid_components?([]), do: true

  defp valid_components?([component | rest]) do
    component != <<>> and component != "." and component != ".." and
      :binary.match(component, <<0>>) == :nomatch and valid_components?(rest)
  end
end
