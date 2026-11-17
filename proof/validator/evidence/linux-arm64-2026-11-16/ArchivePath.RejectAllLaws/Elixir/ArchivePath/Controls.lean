module

public import Lynx
import Lynx.Runner.Elab

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Controls

section

set_option «match».ignoreUnusedAlts true

def «reject_all/1» (_0 : Lynx.Term) : Except Lynx.Exception Lynx.Term :=
  pure (Lynx.Term.tuple #[Lynx.Term.atom "error", Lynx.Term.atom "invalid_path"])

end

end Elixir.ArchivePath.Controls
