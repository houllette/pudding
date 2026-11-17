-- Shared checked postlude. No executable translation is replaced here.
namespace ArchivePathProof
open Lynx
open Term.Bitstring

private abbrev B (bytes : List UInt8) : Term :=
  .bitstring ⟨bytes.toArray⟩ 0 (valid_aligned _)
private abbrev L (parts : List (List UInt8)) : Term := Term.list (parts.map B)
private abbrev bad : Term := .tuple #[.atom "error", .atom "invalid_path"]
private abbrev goodResult (parts : List (List UInt8)) : Term := .tuple #[.atom "ok", L parts]
private def forbidden (part : List UInt8) : Prop := part = [] ∨ part = [46] ∨ part = [46, 46]
private instance (part : List UInt8) : Decidable (forbidden part) := inferInstanceAs (Decidable (_ ∨ _ ∨ _))
private def good (part : List UInt8) : Prop := ¬ forbidden part ∧ (0 : UInt8) ∉ part
private instance (part : List UInt8) : Decidable (good part) := inferInstanceAs (Decidable (_ ∧ _))
private def allGood (parts : List (List UInt8)) : Prop := ∀ p ∈ parts, good p
private instance (parts : List (List UInt8)) : Decidable (allGood parts) := List.decidableBAll good parts

@[simp] private theorem B_inj (a b : List UInt8) : B a = B b ↔ a = b := by
  simp [B, ByteArray.mk.injEq]

@[simp] private theorem exact_bytes (a b : List UInt8) :
    Term.compareExact (Term.fuel (B a) (B b)) (B a) (B b) = .eq ↔ a = b := by
  simp [B, Term.binary_compareExact_eq, ByteArray.mk.injEq]

@[simp] private theorem equal_bytes (a b : List UInt8) :
    Term.compare (Term.fuel (B a) (B b)) (B a) (B b) = .eq ↔ a = b := by
  simp [B, Term.binary_compare_eq, ByteArray.mk.injEq]

private theorem member_forbidden (part : List UInt8) :
    Erlang.lists.«member/2» (B part) (L [[], [46], [46,46]]) =
      .ok (if forbidden part then Term.true else Term.false) := by
  simp [L, Erlang.lists.«member/2», forbidden]
  split <;> simp_all
  split <;> simp_all
  split <;> simp_all

private theorem reverse2 (parts tail : List Term) :
    Erlang.lists.«reverse/2» (Term.list parts) (Term.list tail) = .ok (Term.list (parts.reverse ++ tail)) := by
  induction parts generalizing tail with
  | nil => simp [Erlang.lists.«reverse/2»]
  | cons p ps ih => simpa [Erlang.lists.«reverse/2», List.reverse_cons, List.append_assoc] using ih (p :: tail)

private theorem reverse1 (parts : List Term) :
    Erlang.lists.«reverse/1» (Term.list parts) = .ok (Term.list parts.reverse) := by
  cases parts with
  | nil => rfl
  | cons p ps =>
    cases ps with
    | nil => rfl
    | cons q qs =>
      cases qs with
      | nil => rfl
      | cons r rs =>
        simpa [Erlang.lists.«reverse/1», List.reverse_cons, List.append_assoc] using
          reverse2 (r :: rs) [q, p]

private theorem finish (part : List UInt8) (done : List (List UInt8)) :
    Elixir.ArchivePath.Fixed.«finish/2» (B part) (L done) =
      .ok (if forbidden part then bad else goodResult (done.reverse ++ [part])) := by
  simp only [Elixir.ArchivePath.Fixed.«finish/2», show
    Term.list [Term.bitstring ⟨#[]⟩ 0 (by decide), Term.bitstring ⟨#[46]⟩ 0 (by decide),
      Term.bitstring ⟨#[46,46]⟩ 0 (by decide)] = L [[], [46], [46,46]] from rfl,
    member_forbidden]
  split
  · rfl
  · change (do let x ← Erlang.lists.«reverse/1» (Term.list (B part :: done.map B)); pure (Term.tuple #[.atom "ok", x])) = _
    rw [reverse1]
    simp [goodResult, L, List.map_reverse]

private theorem tail (bytes : List UInt8) : matchTail (B bytes) (.atom "all") 8 := by
  simp [matchTail, bitSize]
  split <;> omega

private theorem scan_nil (part : List UInt8) (done : List (List UInt8)) :
    Elixir.ArchivePath.Fixed.«scan/3» (B []) (B part) (L done) =
      .ok (if forbidden part then bad else goodResult (done.reverse ++ [part])) := by
  rw [Elixir.ArchivePath.Fixed.«scan/3».eq_def]
  simp [B, matchEnd_byte_nil, finish]

private theorem scan_zero (bytes part : List UInt8) (done : List (List UInt8)) :
    Elixir.ArchivePath.Fixed.«scan/3» (B (0 :: bytes)) (B part) (L done) = .ok bad := by
  rw [Elixir.ArchivePath.Fixed.«scan/3».eq_def]
  simp [B, matchEnd_byte, matchInteger_byte, tail, extract]

private theorem scan_slash (bytes part : List UInt8) (done : List (List UInt8)) :
    Elixir.ArchivePath.Fixed.«scan/3» (B (47 :: bytes)) (B part) (L done) =
      if forbidden part then .ok bad else
        Elixir.ArchivePath.Fixed.«scan/3» (B bytes) (B []) (L (part :: done)) := by
  rw [Elixir.ArchivePath.Fixed.«scan/3».eq_def]
  simp only [show B (47 :: bytes) = .bitstring ⟨((47 : UInt8) :: bytes).toArray⟩ 0 (valid_aligned _) from rfl,
    matchEnd_byte, matchInteger_byte]
  simp [extract, tail, show
    Term.list [Term.bitstring ⟨#[]⟩ 0 (by decide), Term.bitstring ⟨#[46]⟩ 0 (by decide),
      Term.bitstring ⟨#[46,46]⟩ 0 (by decide)] = L [[], [46], [46,46]] from rfl,
    member_forbidden]
  by_cases h : forbidden part <;> simp_all [L]

private theorem scan_byte (byte : UInt8) (bytes part : List UInt8) (done : List (List UInt8))
    (nonzero : byte ≠ 0) (nonslash : byte ≠ 47) :
    Elixir.ArchivePath.Fixed.«scan/3» (B (byte :: bytes)) (B part) (L done) =
      Elixir.ArchivePath.Fixed.«scan/3» (B bytes) (B (part ++ [byte])) (L done) := by
  have nz : (byte.toNat : Int) ≠ 0 := by
    intro h
    apply nonzero
    apply UInt8.toNat_inj.mp
    change byte.toNat = 0
    omega
  have ns : (byte.toNat : Int) ≠ 47 := by
    intro h
    apply nonslash
    apply UInt8.toNat_inj.mp
    change byte.toNat = 47
    omega
  rw [Elixir.ArchivePath.Fixed.«scan/3».eq_def]
  simp only [matchEnd_byte, matchInteger_byte]
  simp [extract, tail, ns]
  split
  · rename_i h
    exact False.elim (nz (Term.integer.inj h))
  · simp only [binarySegment_aligned, integerSegment_byte, Except.bind]
    change (do let x ← append (B part) (B [byte]); Elixir.ArchivePath.Fixed.«scan/3» (B bytes) x (L done)) = _
    rw [append_bytes]
    rfl

private theorem consume (chunk rest part : List UInt8) (done : List (List UInt8))
    (nozero : (0 : UInt8) ∉ chunk) (noslash : (47 : UInt8) ∉ chunk) :
    Elixir.ArchivePath.Fixed.«scan/3» (B (chunk ++ rest)) (B part) (L done) =
      Elixir.ArchivePath.Fixed.«scan/3» (B rest) (B (part ++ chunk)) (L done) := by
  induction chunk generalizing part with
  | nil => simp
  | cons b bs ih =>
    simp only [List.mem_cons, not_or] at nozero noslash
    rw [List.cons_append, scan_byte b (bs ++ rest) part done
      (Ne.symm nozero.1) (Ne.symm noslash.1), ih _ nozero.2 noslash.2]
    simp [List.append_assoc]

-- Standard-library decomposition, connected to the public binary split model below.
private theorem separated (bytes : List UInt8) : ∀ part ∈ bytes.splitOn 47, (47 : UInt8) ∉ part := by
  induction bytes with
  | nil => simp
  | cons b bs ih =>
    rw [List.splitOn_cons_eq_ite_modifyHead]
    split
    · simp_all
    · obtain ⟨p, ps, eq⟩ := List.exists_cons_of_ne_nil (List.splitOn_ne_nil 47 bs)
      rw [eq] at ih ⊢
      simp only [List.modifyHead_cons, List.mem_cons, forall_eq_or_imp] at *
      constructor
      · simp_all
        exact Ne.symm ‹b ≠ 47›
      · exact ih.2

private theorem first_occurrence (c : UInt8) (part : List UInt8) (mem : c ∈ part) :
    ∃ before after, part = before ++ c :: after ∧ c ∉ before := by
  induction part with
  | nil => simp at mem
  | cons b bs ih =>
    by_cases eq : b = c
    · subst b; exact ⟨[], bs, rfl, by simp⟩
    · have tailmem : c ∈ bs := by simpa [eq, Ne.symm eq] using mem
      obtain ⟨before, after, rfl, absent⟩ := ih tailmem
      exact ⟨b :: before, after, rfl, by simp [absent, Ne.symm eq]⟩

private theorem match_nul (part : List UInt8) :
    (do let result ← Erlang.binary.«match/2» (B part) (B [0]);
        Erlang.erlang.«==/2» result (.atom "nomatch")) =
      .ok (if (0 : UInt8) ∈ part then Term.false else Term.true) := by
  by_cases h : (0 : UInt8) ∈ part
  · obtain ⟨before, after, eq, absent⟩ := first_occurrence 0 part h
    rw [eq, Erlang.binary.match_first 0 before after absent]
    simp [Erlang.erlang.«==/2», Term.compare_step, Term.Compare.compareStep]
  · rw [Erlang.binary.match_absent 0 part h]
    simp [Erlang.erlang.«==/2», h]

private theorem valid_components (parts : List (List UInt8)) :
    Elixir.Pudding.Contracts.PathPolicy.«valid_components?/1» (L parts) =
      .ok (if allGood parts then Term.true else Term.false) := by
  induction parts with
  | nil => simp [L, Elixir.Pudding.Contracts.PathPolicy.«valid_components?/1», allGood]
  | cons part parts ih =>
    simp only [L, List.map_cons, Elixir.Pudding.Contracts.PathPolicy.«valid_components?/1»]
    change Lynx.Except.andAlso
      (Lynx.Except.andAlso (Lynx.Except.andAlso
        (Lynx.Except.andAlso (Erlang.erlang.«/=/2» (B part) (B []))
          (Erlang.erlang.«/=/2» (B part) (B [46])))
        (Erlang.erlang.«/=/2» (B part) (B [46,46])))
        (do let r ← Erlang.binary.«match/2» (B part) (B [0]); Erlang.erlang.«==/2» r (.atom "nomatch")))
      (Elixir.Pudding.Contracts.PathPolicy.«valid_components?/1» (L parts)) = _
    rw [match_nul, ih]
    simp [Erlang.erlang.«/=/2», Lynx.Except.andAlso, Term.true, Term.false]
    by_cases a : part = [] <;> by_cases b : part = [46] <;>
      by_cases c : part = [46,46] <;> by_cases d : (0 : UInt8) ∈ part <;>
      by_cases e : allGood parts <;> simp_all [allGood, good, forbidden]

private theorem reference (bytes : List UInt8) :
    Elixir.Pudding.Contracts.PathPolicy.«expected/1» (B bytes) =
      .ok (if allGood (bytes.splitOn 47) then goodResult (bytes.splitOn 47) else bad) := by
  have split := Erlang.binary.split_global_intercalate 47 (bytes.splitOn 47)
    (List.splitOn_ne_nil 47 bytes) (separated bytes)
  rw [List.intercalate_splitOn] at split
  simp only [Elixir.Pudding.Contracts.PathPolicy.«expected/1», Elixir.Pudding.Contracts.PathPolicy.«split_slash/1»]
  rw [split]
  change (do let v ← Elixir.Pudding.Contracts.PathPolicy.«valid_components?/1» (L (bytes.splitOn 47)); _) = _
  rw [valid_components]
  split <;> simp_all [allGood]

-- Strong scanner invariant: arbitrary previously completed components and a
-- current NUL-free component. Induction is over separated components, not a
-- bounded byte sample. Any NUL in a component is rejected immediately.
private theorem scanner (parts : List (List UInt8)) (done : List (List UInt8))
    (nonempty : parts ≠ []) (absent : ∀ p ∈ parts, (47 : UInt8) ∉ p) :
    Elixir.ArchivePath.Fixed.«scan/3» (B (List.intercalate [47] parts)) (B []) (L done) =
      .ok (if allGood parts then goodResult (done.reverse ++ parts) else bad) := by
  induction parts generalizing done with
  | nil => exact absurd rfl nonempty
  | cons part parts ih =>
    have noslash := absent part (by simp)
    by_cases nul : (0 : UInt8) ∈ part
    · obtain ⟨before, after, eq, nozero⟩ := first_occurrence 0 part nul
      have bn : (47 : UInt8) ∉ before := by
        intro h
        apply noslash
        rw [eq]
        exact List.mem_append_left _ h
      have reject : ∀ rest, Elixir.ArchivePath.Fixed.«scan/3» (B (part ++ rest)) (B []) (L done) = .ok bad := by
        intro rest
        rw [eq, List.append_assoc, List.cons_append, consume before (0 :: (after ++ rest)) [] done nozero bn]
        exact scan_zero _ _ _
      cases parts with
      | nil => simpa [allGood, good, nul] using reject []
      | cons p ps =>
        rw [List.intercalate_cons_cons, List.append_assoc, List.singleton_append, reject]
        simp [allGood, good, nul]
    · cases parts with
      | nil =>
        simp only [List.intercalate_singleton]
        rw [show part = part ++ [] from (List.append_nil part).symm, consume part [] [] done nul noslash]
        by_cases f : forbidden part <;> simp [scan_nil, allGood, good, nul, f]
      | cons p ps =>
        rw [List.intercalate_cons_cons, List.append_assoc, List.singleton_append, consume part (47 :: List.intercalate [47] (p :: ps)) [] done nul noslash]
        simp only [List.nil_append, scan_slash]
        by_cases f : forbidden part
        · simp [allGood, f, good]
        · rw [ite_eq_right f, ih (part :: done) (by simp) (by
            intro a mem; exact absent a (by simp [mem]))]
          simp [allGood, good, f, nul, List.append_assoc]

theorem binary_contract (input : Term)
    (requires : Elixir.ArchivePath.Laws.«binary_contract:requires/1» input = .ok Term.true) :
    Elixir.ArchivePath.Laws.«binary_contract:ensures/1» input = .ok Term.true := by
  cases input <;> simp [Elixir.ArchivePath.Laws.«binary_contract:requires/1», Erlang.erlang.«is_binary/1»] at requires
  rename_i bytes bits valid
  by_cases aligned : bits = 0
  · subst bits
    obtain ⟨array⟩ := bytes
    obtain ⟨bs⟩ := array
    have fixed : Elixir.ArchivePath.Fixed.«validate/1» (B bs) =
        .ok (if allGood (bs.splitOn 47) then goodResult (bs.splitOn 47) else bad) := by
      simp only [Elixir.ArchivePath.Fixed.«validate/1»]
      have h := scanner (bs.splitOn 47) [] (List.splitOn_ne_nil 47 bs) (separated bs)
      rw [List.intercalate_splitOn] at h
      by_cases g : allGood (bs.splitOn 47) <;> simp only [g, ite_true, ite_false, List.reverse_nil, List.nil_append] at h ⊢ <;> exact h
    change Elixir.ArchivePath.Laws.«binary_contract:ensures/1» (B bs) = _
    simp only [Elixir.ArchivePath.Laws.«binary_contract:ensures/1», fixed, reference]
    simp [Erlang.erlang.«=:=/2»]
  · simp [aligned] at requires

theorem nonbinary_wrapper (input : Term)
    (requires : Elixir.ArchivePath.Laws.«nonbinary_wrapper:requires/1» input = .ok Term.true) :
    Elixir.ArchivePath.Laws.«nonbinary_wrapper:ensures/1» input = .ok Term.true := by
  cases input <;> simp [Elixir.ArchivePath.Laws.«nonbinary_wrapper:requires/1»,
    Erlang.erlang.«is_binary/1», Erlang.erlang.«not/1»] at requires ⊢
  all_goals try { simp [Elixir.ArchivePath.Laws.«nonbinary_wrapper:ensures/1»,
    Elixir.ArchivePath.Fixed.«validate/1», Erlang.erlang.«=:=/2»] }
  rename_i bytes bits valid
  by_cases aligned : bits = 0
  · subst bits
    simp at requires
  · simp [Elixir.ArchivePath.Laws.«nonbinary_wrapper:ensures/1»,
      Elixir.ArchivePath.Fixed.«validate/1», Erlang.erlang.«=:=/2», aligned]

end ArchivePathProof
