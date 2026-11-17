defmodule ArchivePath.Laws do
  @moduledoc """
  Accepted full-domain obligations. Proof sources live under proof/validator;
  verification requires its shared checked postlude. These are direct Lynx
  feasibility artifacts, never Pudding product receipts.
  """
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input),
    expects: ArchivePath.Fixed.validate(input) === PathPolicy.expected(input),
    proof: ~LEAN"exact ArchivePathProof.binary_contract input requires"
  )

  @spec nonbinary_wrapper(input :: term()) :: true
  law(nonbinary_wrapper(input),
    requires: not is_binary(input),
    expects: ArchivePath.Fixed.validate(input) === {:error, :not_binary},
    proof: ~LEAN"exact ArchivePathProof.nonbinary_wrapper input requires"
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
