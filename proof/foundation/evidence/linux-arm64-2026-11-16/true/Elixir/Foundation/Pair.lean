module

public import Lynx
import Lynx.Runner.Elab

@[expose] public section

namespace Elixir.Foundation.Pair

section

set_option «match».ignoreUnusedAlts true

def «swap/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  match _0 with
  | Lynx.Term.tuple ⟨[«_v_left@1», «_v_right@1»]⟩ =>
    pure (Lynx.Term.tuple #[«_v_right@1», «_v_left@1»])
  | _1 => Except.error (Lynx.Exception.error (Lynx.Term.atom "function_clause"))

end

end Elixir.Foundation.Pair
