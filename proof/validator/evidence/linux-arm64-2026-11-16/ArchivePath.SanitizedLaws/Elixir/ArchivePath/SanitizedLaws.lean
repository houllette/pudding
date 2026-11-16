module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.ArchivePath.Controls
public import Elixir.Pudding.Contracts.PathPolicy
public import Lynx.Modules.Erlang.erlang

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.SanitizedLaws

section

set_option «match».ignoreUnusedAlts true

def «binary_contract:ensures/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term := do
  let _2 ← Elixir.ArchivePath.Controls.«sanitized/1» _0
  let _1 ← Elixir.Pudding.Contracts.PathPolicy.«expected/1» _0
  Erlang.erlang.«=:=/2» _2 _1

def «binary_contract:requires/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  Erlang.erlang.«is_binary/1» _0

end

end Elixir.ArchivePath.SanitizedLaws
