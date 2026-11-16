#!/bin/sh
# Runs only inside the offline qualification container, never on the host.
set -eu
umask 077
mkdir -p "$HOME" /scratch/work
cd /scratch/work

# Fail closed if the outer environment is not the one this recipe qualifies.
test "$(id -u)" != 0
test "$(cat /proc/sys/kernel/hostname)" != ""
test ! -e /var/run/docker.sock
test ! -e /run/podman/podman.sock
test -z "${GITHUB_TOKEN:-}${GH_TOKEN:-}${AWS_SECRET_ACCESS_KEY:-}"
if touch /inputs/write-probe 2>/dev/null; then exit 1; fi
if touch /opt/write-probe 2>/dev/null; then exit 1; fi
test "$(ls /sys/class/net)" = lo
# This is the same namespace mechanism required by lake check, not an opt-out.
bwrap --ro-bind / / --tmpfs /home --tmpfs /root --tmpfs /run/user \
  --tmpfs /tmp --dir /tmp/home --dev /dev --proc /proc --clearenv \
  --tmpfs /run --tmpfs /var --setenv HOME /tmp/home \
  --unshare-all --die-with-parent --new-session --chdir /tmp \
  /bin/sh -c 'test "$(ls /sys/class/net)" = lo; ! touch /opt/probe 2>/dev/null'
printf 'Outer read-only/network/credential probes and inner bwrap probe passed\n'

ulimit -a
uname -a
elixir --version
elixir -e 'IO.puts("OTP_RELEASE=" <> File.read!(Path.join([:code.root_dir(), "releases", System.otp_release(), "OTP_VERSION"]))); IO.puts("ERTS=" <> List.to_string(:erlang.system_info(:version)))'
lean --version
lake --version
bwrap --version
sha256sum /opt/lean/bin/lean /opt/lean/bin/lake
find /opt/lean -maxdepth 3 -type f \( -name '*checker*' -o -name '*lean4lean*' -o -name '*nanoda*' -o -name '*con-leche*' -o -name '*con-ron*' -o -name '*leanexport*' \) -exec sha256sum '{}' ';'
dpkg-query -W -f='${Package} ${Version}\n' > /out/os-packages.txt
sha256sum /opt/lean/LICENSE /opt/lean/LICENSES > /out/license-digests.txt
cp /opt/lean/LICENSE /out/lean-LICENSE.txt
cp /opt/lean/LICENSES /out/lean-LICENSES.txt

tar -xf /inputs/source.tar -C /scratch/work
test "$(cat lean-toolchain)" = leanprover/lean4:v4.35.0
test "$(uname -m)" = aarch64
elixir -e 'true = System.version() == "1.20.2"; true = String.trim(File.read!(Path.join([:code.root_dir(), "releases", System.otp_release(), "OTP_VERSION"]))) == "29.0.2"'
lean --version | grep -F 'version 4.35.0, aarch64-unknown-linux-gnu, commit eb6cafb7290e8bd5f2937522d8d804f58f02bafc'
# Pre-fetched source only: no network or package resolver at execution time.
mkdir -p deps
git clone --quiet /inputs/lynx.bundle deps/lynx
git -C deps/lynx checkout --quiet 99a6db764c154207cf3b28c35409d9b56c463357
# Mix checks both revision and original declared URL; no fetch is performed.
git -C deps/lynx remote set-url origin https://github.com/josevalim/lynx.git
test "$(git -C deps/lynx rev-parse HEAD)" = 99a6db764c154207cf3b28c35409d9b56c463357
sha256sum /inputs/source.tar /inputs/lynx.bundle /inputs/qualify.sh > /out/input-digests.txt
find lib proof/validator test/fixtures/projects/archive_path/lib -type f -exec sha256sum '{}' ';' > /out/source-digests.txt

cd test/fixtures/projects/archive_path
mkdir -p deps
ln -s /scratch/work/deps/lynx deps/lynx
# The consumer lock is checked in; --no-deps-check would conceal a broken dependency.
timeout 1200 mix compile --warnings-as-errors
started=$(date +%s)
VALIDATOR_OUTPUT=/out timeout 600 mix run --no-compile proof_qualification_test.exs
printf 'Proof harness elapsed seconds: %s\n' "$(($(date +%s) - started))"
elixir -pa _build/prod/lib/archive_path/ebin -pa _build/prod/lib/pudding/ebin -e '
  File.mkdir_p!("/out/beam")
  File.mkdir_p!("/out/core")
  for module <- [ArchivePath.Fixed, ArchivePath.Vulnerable, ArchivePath.Laws, Pudding.Contracts.PathPolicy, :lists] do
    path = :code.which(module)
    {:ok, bytes} = File.read(path)
    File.write!("/out/beam/#{module}.beam", bytes)
    {:ok, {^module, [debug_info: {backend_version, backend, data}]}} = :beam_lib.chunks(bytes, [:debug_info])
    File.write!("/out/beam/#{module}.debug.etf", :erlang.term_to_binary({backend_version, backend, data}))
    {:ok, {^module, [compile_info: info]}} = :beam_lib.chunks(bytes, [:compile_info])
    File.write!("/out/beam/#{module}.compile-info.txt", inspect(info, pretty: true, limit: :infinity))
    {:ok, core} = backend.debug_info(:core_v1, module, data, [])
    File.write!("/out/core/#{module}.core.etf", :erlang.term_to_binary(core))
    File.write!("/out/core/#{module}.core", :core_pp.format(core))
  end'
cd /scratch/work
find test/fixtures/projects/archive_path/_build -type f -name '*.beam' -exec sha256sum '{}' ';' > /out/beam-digests.txt
sha256sum -c /out/source-digests.txt
sha256sum /out/fixed/proof.ndjson > /out/export-digest.txt
# No sandbox bypass flag; all six checkers and full export closure must pass.
started=$(date +%s)
if timeout 600 lake --dir deps/lynx/Lean check --paranoid --from-export /out/fixed/proof.ndjson > /out/checker.log 2>&1; then
  cat /out/checker.log
else
  cat /out/checker.log
  exit 1
fi
printf 'Independent checker elapsed seconds: %s\n' "$(($(date +%s) - started))"
for kernel in 'Lean paranoid' lean4lean nanoda con-leche con-ron 'Lean default'; do
  grep -F "$kernel kernel accepts the solution" /out/checker.log
done
grep -Fx 'Uses axioms: propext, Quot.sound, Classical.choice' /out/checker.log
# A malformed export must be rejected, not silently skipped or treated as proof.
printf '{invalid-json}\n' > /out/malformed.ndjson
set +e
timeout 60 lake --dir deps/lynx/Lean check --paranoid --from-export /out/malformed.ndjson > /out/malformed-checker.log 2>&1
status=$?
set -e
cat /out/malformed-checker.log
test "$status" = 1
grep -F 'kernel rejected the solution' /out/malformed-checker.log
if grep -E 'bwrap:|not found|Permission denied|Read-only file system' /out/malformed-checker.log; then
  exit 1
fi
# A syntactically valid changed proof of the required binary theorem must fail
# logical checking (not only parsing). Name resolution follows export v3 records.
elixir -e '
  source = "/out/fixed/proof.ndjson"
  dest = File.open!("/out/tampered.ndjson", [:write])
  {_names, 1} = Enum.reduce(File.stream!(source), {%{0 => ""}, 0}, fn line, {names, count} ->
    record = :json.decode(line)
    names = case record do
      %{"in" => id, "str" => %{"pre" => pre, "str" => str}} ->
        Map.put(names, id, Enum.join(Enum.reject([Map.fetch!(names, pre), str], &(&1 == "")), "."))
      %{"in" => id, "num" => %{"pre" => pre, "i" => i}} -> Map.put(names, id, "#{Map.fetch!(names, pre)}.#{i}")
      _ -> names
    end
    {record, count} = case record do
      %{"thm" => %{"name" => name} = thm} ->
        if names[name] == "Elixir.ArchivePath.Laws.laws.binary_contract/1" do
          {Map.put(record, "thm", Map.put(thm, "value", 0)), count + 1}
        else
          {record, count}
        end
      _ -> {record, count}
    end
    IO.binwrite(dest, [:json.encode(record), "\n"])
    {names, count}
  end)
  File.close(dest)'
set +e
timeout 120 lake --dir deps/lynx/Lean check --paranoid --from-export /out/tampered.ndjson > /out/tampered-checker.log 2>&1
status=$?
set -e
cat /out/tampered-checker.log
test "$status" = 1
grep -F 'kernel rejected the solution' /out/tampered-checker.log
if grep -E 'bwrap:|not found|Permission denied|Read-only file system' /out/tampered-checker.log; then exit 1; fi
sha256sum /out/tampered.ndjson > /out/tampered-digest.txt
printf 'VALIDATOR_GATE_PASSED\n'
# Cgroup cumulative usage for this container (not machine-wide or human time).
for metric in memory.peak memory.events cpu.stat pids.peak; do
  if test -r "/sys/fs/cgroup/$metric"; then
    printf '\n%s\n' "$metric"
    cat "/sys/fs/cgroup/$metric"
  fi
done > /out/resource-usage.txt
cat /out/resource-usage.txt
