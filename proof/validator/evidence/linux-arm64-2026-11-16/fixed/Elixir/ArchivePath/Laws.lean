module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.ArchivePath.Fixed
public import Elixir.Pudding.Contracts.PathPolicy
public import Lynx.Modules.Erlang.erlang

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Laws

section

set_option «match».ignoreUnusedAlts true

def «binary_contract:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _2 ← Elixir.ArchivePath.Fixed.«validate/1» _0
  let _1 ← Elixir.Pudding.Contracts.PathPolicy.«expected/1» _0
  Erlang.erlang.«=:=/2» _2 _1

def «binary_contract:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  Erlang.erlang.«is_binary/1» _0

def «nonbinary_wrapper:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _1 ← Elixir.ArchivePath.Fixed.«validate/1» _0
  Erlang.erlang.«=:=/2» _1 (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "not_binary"])

def «nonbinary_wrapper:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _1 ← Erlang.erlang.«is_binary/1» _0
  Erlang.erlang.«not/1» _1

end

end Elixir.ArchivePath.Laws
