module

public import Lynx
import Lynx.Runner.Elab
public import Elixir.ArchivePath.AdmittedLaws
meta import Elixir.ArchivePath.AdmittedLaws

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.AdmittedLaws.laws

theorem «admitted/0» : «admitted:ensures/0» = Except.ok Lynx.Term.true := by
  have false_helper : False := by sorry
  exact False.elim false_helper

end Elixir.ArchivePath.AdmittedLaws.laws
