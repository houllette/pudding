module

public import Lynx
import Lynx.Runner.Elab
public import Lynx.Modules.Erlang.binary
public import Lynx.Modules.Erlang.erlang

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Vulnerable

section

set_option «match».ignoreUnusedAlts true

def «valid_components?/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  match _0 with
  | Lynx.Term.nil => pure (Lynx.Term.atom "true")
  | Lynx.Term.cons «_v_component@1» «_v_rest@1» =>
    Lynx.Except.andAlso
      (Lynx.Except.andAlso
        (Lynx.Except.andAlso
          (Erlang.erlang.«/=/2» «_v_component@1» (Lynx.Term.bitstring ⟨#[]⟩ 0 (by decide)))
          (Erlang.erlang.«/=/2» «_v_component@1» (Lynx.Term.bitstring ⟨#[46]⟩ 0 (by decide))))
        do
        let _3 ← Erlang.binary.«match/2» «_v_component@1» (Lynx.Term.bitstring ⟨#[0]⟩ 0 (by decide))
        Erlang.erlang.«==/2» _3 (Lynx.Term.atom "nomatch"))
      («valid_components?/1» «_v_rest@1»)
  | _7 => Except.error (Lynx.Exception.error (Lynx.Term.atom "function_clause"))

def «validate/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  match _0 with
  | «_v_input@1»@(Lynx.Term.bitstring _ 0 _) => do
    let «_v_components@1» ←
      Erlang.binary.«split/3» «_v_input@1» (Lynx.Term.bitstring ⟨#[47]⟩ 0 (by decide))
          (Lynx.Term.list [Lynx.Term.atom "global"])
    let _2 ←
      Erlang.binary.«match/2» «_v_input@1» (Lynx.Term.bitstring ⟨#[46, 46, 47]⟩ 0 (by decide))
    let _4 ←
      Lynx.Except.andAlso (Erlang.erlang.«==/2» _2 (Lynx.Term.atom "nomatch"))
          («valid_components?/1» «_v_components@1»)
    (fun {lynxValue : Type}
            (lynxBody : (Unit → Except Lynx.Exception lynxValue) → Except Lynx.Exception lynxValue)
            (lynxNext : Unit → Except Lynx.Exception lynxValue) =>
          lynxBody lynxNext)
        (fun lynxMatchNext =>
          match _4 with
          | _v_1 =>
            Lynx.Except.guard
              (Except.ok (Lynx.Term.isMember _4 [Lynx.Term.atom "false", Lynx.Term.atom "nil"]))
              (fun _ =>
                pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "invalid_path"]))
              lynxMatchNext)
        (fun (_ : Unit) =>
          match _4 with
          | _10 => pure (Lynx.Term.tuple #[Lynx.Term.atom "ok", «_v_components@1»]))
  | «_v__input@1» => pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "not_binary"])

end

end Elixir.ArchivePath.Vulnerable
