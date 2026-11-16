module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.Foundation.Laws
meta import Elixir.Foundation.Laws

@[expose] public section

namespace Elixir.Foundation.Laws.laws

theorem «involution/2» (left : Lynx.Term) (right : Lynx.Term) :
    «involution:ensures/2» left right = Except.ok Lynx.Term.true := by
  simp [«involution:ensures/2», Foundation.Pair.«swap/1», Erlang.erlang.«=:=/2»]

end Elixir.Foundation.Laws.laws
