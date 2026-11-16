module

public import Lynx
import Lynx.Runner.Elab
public import Lynx.Modules.Erlang.erlang
public import Erlang.lists

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Fixed

section

set_option «match».ignoreUnusedAlts true

def «finish/2» (_0 : Lynx.Term) (_1 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let lynxGenerated0 ←
    Erlang.lists.«member/2» _0
        (Lynx.Term.list
          [Lynx.Term.bitstring ⟨#[]⟩ 0 (by decide), Lynx.Term.bitstring ⟨#[46]⟩ 0 (by decide),
            Lynx.Term.bitstring ⟨#[46, 46]⟩ 0 (by decide)])
  (match lynxGenerated0 with
    | Lynx.Term.atom "false" => do
      let _2 ← Erlang.lists.«reverse/1» (Lynx.Term.cons _0 _1)
      pure (Lynx.Term.tuple #[Lynx.Term.atom "ok", _2])
    | Lynx.Term.atom "true" =>
      pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "invalid_path"])
    | _3 =>
      Except.error (Lynx.Exception.error (Lynx.Term.tuple #[Lynx.Term.atom "case_clause", _3])))

def «scan/3» (_0 : Lynx.Term) («_v_component@1» : Lynx.Term) («_v_components@1» : Lynx.Term) :
    Except Lynx.Exception Lynx.Term :=
  (fun {lynxValue : Type}
        (lynxBody : (Unit → Except Lynx.Exception lynxValue) → Except Lynx.Exception lynxValue)
        (lynxNext : Unit → Except Lynx.Exception lynxValue) =>
      lynxBody lynxNext)
    (fun lynxMatchNext =>
      match (Lynx.Term.Bitstring.matchEnd _0) with
      | Bool.true => «finish/2» «_v_component@1» «_v_components@1»
      | _ => lynxMatchNext ())
    (fun (_ : Unit) =>
      (fun {lynxValue : Type}
            (lynxBody : (Unit → Except Lynx.Exception lynxValue) → Except Lynx.Exception lynxValue)
            (lynxNext : Unit → Except Lynx.Exception lynxValue) =>
          lynxBody lynxNext)
        (fun lynxMatchNext =>
          Lynx.Term.Bitstring.extract
            (Lynx.Term.Bitstring.matchInteger _0 (Lynx.Term.integer 8) 1 Bool.false Bool.false)
            (fun lynxExtracted lynxBits0 =>
              match lynxExtracted with
              | Lynx.Term.integer 0 =>
                match (Lynx.Term.Bitstring.matchTail lynxBits0 (Lynx.Term.atom "all") 8) with
                | Bool.true =>
                  match (lynxBits0) with
                  | «_v__rest@1» =>
                    pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "invalid_path"])
                | _ => lynxMatchNext ()
              | _ => lynxMatchNext ())
            (fun _ => lynxMatchNext ()))
        (fun (_ : Unit) =>
          (fun {lynxValue : Type}
                (lynxBody :
                  (Unit → Except Lynx.Exception lynxValue) → Except Lynx.Exception lynxValue)
                (lynxNext : Unit → Except Lynx.Exception lynxValue) =>
              lynxBody lynxNext)
            (fun lynxMatchNext =>
              Lynx.Term.Bitstring.extract
                (Lynx.Term.Bitstring.matchInteger _0 (Lynx.Term.integer 8) 1 Bool.false Bool.false)
                (fun lynxExtracted lynxBits1 =>
                  match lynxExtracted with
                  | Lynx.Term.integer 47 =>
                    match (Lynx.Term.Bitstring.matchTail lynxBits1 (Lynx.Term.atom "all") 8) with
                    | Bool.true =>
                      match (lynxBits1) with
                      | «_v_rest@1» => do
                        let lynxGenerated0 ←
                          Erlang.lists.«member/2» «_v_component@1»
                              (Lynx.Term.list
                                [Lynx.Term.bitstring ⟨#[]⟩ 0 (by decide),
                                  Lynx.Term.bitstring ⟨#[46]⟩ 0 (by decide),
                                  Lynx.Term.bitstring ⟨#[46, 46]⟩ 0 (by decide)])
                        (match lynxGenerated0 with
                          | Lynx.Term.atom "false" =>
                            «scan/3» «_v_rest@1» (Lynx.Term.bitstring ⟨#[]⟩ 0 (by decide))
                              (Lynx.Term.cons «_v_component@1» «_v_components@1»)
                          | Lynx.Term.atom "true" =>
                            pure
                              (Lynx.Term.tuple
                                #[Lynx.Term.atom "error", Lynx.Term.atom "invalid_path"])
                          | _3 =>
                            Except.error
                              (Lynx.Exception.error
                                (Lynx.Term.tuple #[Lynx.Term.atom "case_clause", _3])))
                    | _ => lynxMatchNext ()
                  | _ => lynxMatchNext ())
                (fun _ => lynxMatchNext ()))
            (fun (_ : Unit) =>
              (fun {lynxValue : Type}
                    (lynxBody :
                      (Unit → Except Lynx.Exception lynxValue) → Except Lynx.Exception lynxValue)
                    (lynxNext : Unit → Except Lynx.Exception lynxValue) =>
                  lynxBody lynxNext)
                (fun lynxMatchNext =>
                  Lynx.Term.Bitstring.extract
                    (Lynx.Term.Bitstring.matchInteger _0 (Lynx.Term.integer 8) 1 Bool.false
                      Bool.false)
                    (fun «_v_byte@1» lynxBits2 =>
                      match (Lynx.Term.Bitstring.matchTail lynxBits2 (Lynx.Term.atom "all") 8) with
                      | Bool.true =>
                        match (lynxBits2) with
                        | «_v_rest@1» => do
                          let _4 ←
                            Except.bind
                                (Lynx.Term.Bitstring.binarySegment «_v_component@1»
                                  (Lynx.Term.atom "all") 8)
                                (fun lynxBinarySegment =>
                                  Except.bind
                                    (Lynx.Term.Bitstring.integerSegment «_v_byte@1»
                                      (Lynx.Term.integer 8) 1 Bool.false)
                                    (fun lynxBinaryTail =>
                                      Lynx.Term.Bitstring.append lynxBinarySegment lynxBinaryTail))
                          «scan/3» «_v_rest@1» _4 «_v_components@1»
                      | _ => lynxMatchNext ())
                    (fun _ => lynxMatchNext ()))
                (fun (_ : Unit) =>
                  match _0 with
                  | _7 => Except.error (Lynx.Exception.error (Lynx.Term.atom "function_clause"))))))
termination_by sizeOf _0

def «validate/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  match _0 with
  | «_v_input@1»@(Lynx.Term.bitstring _ 0 _) =>
    «scan/3» «_v_input@1» (Lynx.Term.bitstring ⟨#[]⟩ 0 (by decide)) Lynx.Term.nil
  | «_v__input@1» => pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "not_binary"])

end

end Elixir.ArchivePath.Fixed
