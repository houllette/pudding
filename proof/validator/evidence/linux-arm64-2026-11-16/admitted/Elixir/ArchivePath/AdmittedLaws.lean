module

public import Lynx
import Lynx.Runner.Elab

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.AdmittedLaws

section

set_option «match».ignoreUnusedAlts true

def «admitted:ensures/0» : Except Lynx.Exception Lynx.Term :=
  pure (Lynx.Term.atom "false")

end

end Elixir.ArchivePath.AdmittedLaws
