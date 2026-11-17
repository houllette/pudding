module

public import Lynx
import Lynx.Runner.Elab
public import Lynx.Modules.Erlang.lists

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Erlang.lists

section

set_option «match».ignoreUnusedAlts true

def «reverse/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  match _0 with
  | vL@Lynx.Term.nil => pure vL
  | vL@(Lynx.Term.cons _2 Lynx.Term.nil) => pure vL
  | Lynx.Term.cons vA (Lynx.Term.cons vB Lynx.Term.nil) => pure (Lynx.Term.list [vB, vA])
  | Lynx.Term.cons vA (Lynx.Term.cons vB vL) =>
    Erlang.lists.«reverse/2» vL (Lynx.Term.list [vB, vA])
  | _1 => Except.error (Lynx.Exception.error (Lynx.Term.atom "function_clause"))

end

end Erlang.lists
