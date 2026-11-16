defmodule Foundation.Laws do
  @moduledoc "Universal tuple-swap involution; not a security contract."
  use Lynx.Laws

  law(involution(left, right),
    expects: Foundation.Pair.swap(Foundation.Pair.swap({left, right})) === {left, right},
    proof: ~LEAN"""
    simp [«involution:ensures/2», Foundation.Pair.«swap/1», Erlang.erlang.«=:=/2»]
    """
  )
end

defmodule Foundation.AdmittedLaws do
  @moduledoc "Forbidden axiom control: an admitted proof must not verify."
  use Lynx.Laws

  law(admitted, expects: false, proof: ~LEAN"sorry")
end

defmodule Foundation.FalseLaws do
  @moduledoc "Deliberately false control: one swap does not preserve every pair."
  use Lynx.Laws

  law(unchanged(left, right),
    expects: Foundation.Pair.swap({left, right}) === {left, right},
    proof: ~LEAN"rfl"
  )
end
