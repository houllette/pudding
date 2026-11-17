#!/bin/sh
# Offline phase-03 qualification. Bootstrap the image once as documented.
set -eu
root=$(CDPATH='' cd -- "$(dirname "$0")/../.." && pwd)
image=${VALIDATOR_IMAGE:-pudding-foundation:phase01}
output=${1:?Usage: sh proof/validator/run.sh NEW_OUTPUT_DIRECTORY}
# Keep bind sources on the shared workspace filesystem (macOS Podman does
# not share the host /tmp with its Linux VM).
mkdir -p "$root/tmp"
mkdir "$output"
output=$(CDPATH='' cd -- "$output" && pwd)
inputs=$(mktemp -d "$root/tmp/validator-inputs.XXXXXX")
trap 'rm -rf "$inputs"' EXIT HUP INT TERM

# Explicit allowlist: never send .git, credentials, host build caches or deps.
cd "$root"
COPYFILE_DISABLE=1 COPY_EXTENDED_ATTRIBUTES_DISABLE=1 tar -cf "$inputs/source.tar" mix.exs mix.lock lean-toolchain .tool-versions \
  lib proof/validator/lemmas.lean proof/validator/contract \
  test/fixtures/projects/archive_path/mix.exs test/fixtures/projects/archive_path/mix.lock \
  test/fixtures/projects/archive_path/lib test/fixtures/projects/archive_path/test \
  test/fixtures/projects/archive_path/proof_qualification_test.exs
# Committed source only, with SCM identity for ordinary Mix lock checking.
test "$(git -C deps/lynx rev-parse HEAD)" = 99a6db764c154207cf3b28c35409d9b56c463357
git -C deps/lynx bundle create "$inputs/lynx.bundle" HEAD
cp proof/validator/qualify.sh "$inputs/qualify.sh"
cp proof/validator/run.sh proof/foundation/Dockerfile "$output/"
cp "$inputs/source.tar" "$inputs/lynx.bundle" "$inputs/qualify.sh" "$output/"
docker image inspect "$image" > "$output/image.json"
docker version > "$output/container-version.txt"
# The enclosing Linux VM is part of the boundary. No host sockets, credentials,
# environment forwarding, network, root capabilities, or host-writable source.
# seccomp=unconfined allows bwrap's *nested* user namespace, not a privileged run.
# The output owns the record, so redirect this launcher's stdout elsewhere.
date -u '+%Y-%m-%dT%H:%M:%SZ' > "$output/started-at.txt"
set +e
docker run --rm --user "$(id -u):$(id -g)" --network none --read-only --cap-drop ALL \
  --security-opt no-new-privileges --security-opt seccomp=unconfined \
  --security-opt label=disable --security-opt unmask=ALL \
  --pids-limit 256 --memory 6g --memory-swap 6g --cpus 4 \
  --ulimit nofile=1024:1024 --ulimit nproc=256:256 --ulimit core=0:0 \
  --tmpfs /scratch:rw,exec,nosuid,nodev,size=4g,mode=1777 \
  --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 \
  --mount "type=bind,src=$inputs,dst=/inputs,readonly" \
  --mount "type=bind,src=$output,dst=/out" \
  "$image" timeout --signal=KILL 1800 sh /inputs/qualify.sh \
  > "$output/qualification.log" 2>&1
status=$?
set -e
date -u '+%Y-%m-%dT%H:%M:%SZ' > "$output/finished-at.txt"
cat "$output/qualification.log"
printf '%s\n' "$status" > "$output/exit-status.txt"
exit "$status"
