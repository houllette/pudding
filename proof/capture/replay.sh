#!/bin/sh
# Trusted fixture-only replay. No consumer source compilation or Mix evaluation.
set -eu
export PATH=/opt/elixir/bin:/opt/erlang/bin:/opt/lean/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export HOME=/scratch/home MIX_HOME=/scratch/home/.mix HEX_HOME=/scratch/home/.hex
export MIX_ARCHIVES=/opt/mix/archives MIX_ENV=prod ERL_FLAGS='+S 4:4 +fnu'
mkdir -p "$HOME" /scratch/work/deps
cp -R /inputs/lynx /scratch/work/deps/lynx
cd /scratch/work/deps/lynx
timeout 600 mix compile --warnings-as-errors
cd /scratch/work
cp -R /inputs/test .
mkdir -p proof/validator
cp /inputs/proof/validator/lemmas.lean proof/validator/lemmas.lean
export VALIDATOR_OUTPUT=/out
elixir -pa /scratch/work/deps/lynx/_build/prod/lib/lynx/ebin \
  -r /capture/project/manifest.ex -r /capture/project/beam.ex /driver/replay_guest.exs
# Replay must not have created any consumer build.
test ! -e test/fixtures/projects/archive_path/_build
sha256sum /out/fixed/proof.ndjson > /out/export-digest.txt
if timeout 600 lake --dir deps/lynx/Lean check --paranoid --from-export /out/fixed/proof.ndjson > /out/checker.log 2>&1; then
  cat /out/checker.log
else
  cat /out/checker.log
  exit 1
fi
for kernel in 'Lean paranoid' lean4lean nanoda con-leche con-ron 'Lean default'; do
  grep -F "$kernel kernel accepts the solution" /out/checker.log
done
grep -Fx 'Uses axioms: propext, Quot.sound, Classical.choice' /out/checker.log
printf '{invalid-json}\n' > /out/malformed.ndjson
elixir /driver/tamper.exs
for control in malformed tampered; do
  set +e
  timeout 120 lake --dir deps/lynx/Lean check --paranoid --from-export "/out/$control.ndjson" > "/out/$control-checker.log" 2>&1
  status=$?
  set -e
  cat "/out/$control-checker.log"
  test "$status" = 1
  grep -F 'kernel rejected the solution' "/out/$control-checker.log"
  if grep -E 'bwrap:|not found|Permission denied|Read-only file system' "/out/$control-checker.log"; then exit 1; fi
done
sha256sum /out/tampered.ndjson > /out/tampered-digest.txt
for metric in memory.peak memory.events cpu.stat pids.peak; do
  if test -r "/sys/fs/cgroup/$metric"; then
    printf '\n%s\n' "$metric"
    cat "/sys/fs/cgroup/$metric"
  fi
done > /out/resource-usage.txt
printf 'CAPTURED_FIXTURE_REPLAY_PASSED_NOT_PHASE04_CLOSURE\n'
