defmodule ArchivePath.Controls do
  @moduledoc "Deliberately invalid replacements for the full accepted policy."

  @spec reject_all(input :: term()) :: {:error, :invalid_path}
  def reject_all(_input), do: {:error, :invalid_path}

  @spec sanitized(input :: term()) :: {:ok, [binary()]}
  def sanitized(_input), do: {:ok, ["safe"]}
end

defmodule ArchivePath.RejectAllLaws do
  @moduledoc "Safety-only rejection cannot meet useful acceptance."
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input),
    expects: ArchivePath.Controls.reject_all(input) === PathPolicy.expected(input)
  )
end

defmodule ArchivePath.SanitizedLaws do
  @moduledoc "Substituted output cannot meet exact component preservation."
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input),
    expects: ArchivePath.Controls.sanitized(input) === PathPolicy.expected(input)
  )
end

defmodule ArchivePath.StrongerPreconditionLaws do
  @moduledoc "Invalid control: validity excludes the malicious inputs from the obligation."
  use Lynx.Laws

  alias Pudding.Contracts.PathPolicy

  @spec binary_contract(input :: binary()) :: true
  law(binary_contract(input),
    requires: is_binary(input) and match?({:ok, _}, PathPolicy.expected(input)),
    expects: ArchivePath.Vulnerable.validate(input) === PathPolicy.expected(input)
  )
end
