module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.ArchivePath.SanitizedLaws
meta import Elixir.ArchivePath.SanitizedLaws

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.SanitizedLaws.laws

theorem «binary_contract/1» (input : Lynx.Term)
    (requires : «binary_contract:requires/1» input = Except.ok Lynx.Term.true) :
    «binary_contract:ensures/1» input = Except.ok Lynx.Term.true := by
  rfl

end Elixir.ArchivePath.SanitizedLaws.laws
