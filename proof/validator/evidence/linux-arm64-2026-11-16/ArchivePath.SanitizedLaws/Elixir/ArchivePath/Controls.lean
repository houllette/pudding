module

public import Lynx
import Lynx.Runner.Elab

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Controls

section

set_option «match».ignoreUnusedAlts true

def «sanitized/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  pure
    (Lynx.Term.tuple
      #[Lynx.Term.atom "ok",
        Lynx.Term.list [Lynx.Term.bitstring ⟨#[115, 97, 102, 101]⟩ 0 (by decide)]])

end

end Elixir.ArchivePath.Controls
