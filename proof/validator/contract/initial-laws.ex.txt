defmodule ArchivePath.Laws do
  @moduledoc """
  Phase 02 obligations, not completed proofs. Lynx's default `rfl` is merely the
  initial proof attempt; no verification or product receipt is claimed here.
  The reference implementation is separate from this law module.
  """
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input),
    expects: ArchivePath.Fixed.validate(input) === PathPolicy.expected(input)
  )

  @spec nonbinary_wrapper(input :: term()) :: true
  law(nonbinary_wrapper(input),
    requires: not is_binary(input),
    expects: ArchivePath.Fixed.validate(input) === {:error, :not_binary}
  )
end

defmodule ArchivePath.VulnerableLaws do
  @moduledoc "The same full binary obligation for the intentionally vulnerable implementation."
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input),
    expects: ArchivePath.Vulnerable.validate(input) === PathPolicy.expected(input)
  )
end
