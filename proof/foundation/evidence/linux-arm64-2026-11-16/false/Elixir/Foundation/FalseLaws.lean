module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.Foundation.Pair
public import Lynx.Modules.Erlang.erlang

@[expose] public section

namespace Elixir.Foundation.FalseLaws

section

set_option «match».ignoreUnusedAlts true

def «unchanged:ensures/2» (_0 : Lynx.Term) (_1 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _2 ← Elixir.Foundation.Pair.«swap/1» (Lynx.Term.tuple #[_0, _1])
  Erlang.erlang.«=:=/2» _2 (Lynx.Term.tuple #[_0, _1])

end

end Elixir.Foundation.FalseLaws
