#!/bin/sh
# Network-enabled bootstrap; qualification itself is offline.
set -eu
root=$(CDPATH='' cd -- "$(dirname "$0")/../.." && pwd)
context=${1:?Usage: sh proof/foundation/bootstrap.sh NEW_CONTEXT_DIRECTORY}
mkdir "$context"
curl --fail --location --retry 2 \
  https://github.com/leanprover/lean4/releases/download/v4.35.0/lean-4.35.0-linux_aarch64.tar.zst \
  -o "$context/lean-linux.tar.zst"
curl --fail --location --retry 2 \
  https://github.com/hexpm/hex/archive/refs/tags/v2.7.0.tar.gz -o "$context/hex-source.tar.gz"
cp "$root/proof/foundation/Dockerfile" "$context/Dockerfile"
# Dockerfile checks both archives before installation.
docker build --load --platform linux/arm64 -t pudding-foundation:phase01 "$context"
