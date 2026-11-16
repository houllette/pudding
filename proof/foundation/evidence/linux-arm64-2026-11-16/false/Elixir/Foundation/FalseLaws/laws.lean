module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.Foundation.FalseLaws
meta import Elixir.Foundation.FalseLaws

@[expose] public section

namespace Elixir.Foundation.FalseLaws.laws

theorem «unchanged/2» (left : Lynx.Term) (right : Lynx.Term) :
    «unchanged:ensures/2» left right = Except.ok Lynx.Term.true := by
  rfl

end Elixir.Foundation.FalseLaws.laws
