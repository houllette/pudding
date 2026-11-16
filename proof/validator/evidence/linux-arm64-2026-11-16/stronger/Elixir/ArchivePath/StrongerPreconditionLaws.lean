module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.ArchivePath.Vulnerable
public import Elixir.Pudding.Contracts.PathPolicy
public import Lynx.Modules.Erlang.erlang

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.StrongerPreconditionLaws

section

set_option «match».ignoreUnusedAlts true

def «binary_contract:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _2 ← Elixir.ArchivePath.Vulnerable.«validate/1» _0
  let _1 ← Elixir.Pudding.Contracts.PathPolicy.«expected/1» _0
  Erlang.erlang.«=:=/2» _2 _1

def «binary_contract:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  Lynx.Except.andAlso (Erlang.erlang.«is_binary/1» _0) do
    let lynxGenerated0 ← Elixir.Pudding.Contracts.PathPolicy.«expected/1» _0
    (match lynxGenerated0 with
      | Lynx.Term.tuple ⟨[Lynx.Term.atom "ok", _4]⟩ => pure (Lynx.Term.atom "true")
      | _5 => pure (Lynx.Term.atom "false"))

end

end Elixir.ArchivePath.StrongerPreconditionLaws
