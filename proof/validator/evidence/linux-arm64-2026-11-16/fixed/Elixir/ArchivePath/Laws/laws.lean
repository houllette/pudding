module

public import Lynx
import Lynx.Runner.Elab
public import Erlang.postlude
public import Elixir.ArchivePath.Laws
meta import Erlang.postlude
meta import Elixir.ArchivePath.Laws

@[expose] public section

set_option maxHeartbeats 2000000

set_option maxRecDepth 4096

namespace Elixir.ArchivePath.Laws.laws

theorem «binary_contract/1» (input : Lynx.Term)
    (requires : «binary_contract:requires/1» input = Except.ok Lynx.Term.true) :
    «binary_contract:ensures/1» input = Except.ok Lynx.Term.true := by
  exact ArchivePathProof.binary_contract input requires

theorem «nonbinary_wrapper/1» (input : Lynx.Term)
    (requires : «nonbinary_wrapper:requires/1» input = Except.ok Lynx.Term.true) :
    «nonbinary_wrapper:ensures/1» input = Except.ok Lynx.Term.true := by
  exact ArchivePathProof.nonbinary_wrapper input requires

end Elixir.ArchivePath.Laws.laws
