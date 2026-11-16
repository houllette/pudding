defmodule ArchivePath.Vulnerable do
  @moduledoc """
  Intentionally synthetic defect: rejects `../` but accepts exact `..` components
  at end of input. This is NOT a reproduction of the historical OTP ZIP advisory.
  Kept separately from the fixed implementation for later counterexample replay.
  """

  @doc "Checks a flawed byte substring rule, preserving the vulnerable behavior."
  @spec validate(input :: term()) ::
          {:ok, [binary()]} | {:error, :invalid_path | :not_binary}
  def validate(input) when is_binary(input) do
    components = :binary.split(input, <<47>>, [:global])

    if :binary.match(input, "../") == :nomatch and valid_components?(components),
      do: {:ok, components},
      else: {:error, :invalid_path}
  end

  def validate(_input), do: {:error, :not_binary}

  defp valid_components?([]), do: true

  defp valid_components?([component | rest]) do
    component != <<>> and component != "." and
      :binary.match(component, <<0>>) == :nomatch and valid_components?(rest)
  end
end
