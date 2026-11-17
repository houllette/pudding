#!/bin/sh
# Trusted entrypoint. No consumer process is alive during inspection/export.
set -eu
umask 077
mkdir -p "$HOME"
test "$(id -u)" = 1000
test "$(uname -m)" = aarch64
test "$(ls /sys/class/net)" = lo
test ! -e /var/run/docker.sock
test ! -e /run/podman/podman.sock
case "$1" in
  tools)
    mkdir -p /tool/capture
    elixirc --warnings-as-errors -o /tool/capture /trusted/pudding/lib/project/*.ex /trusted/pudding/lib/execution/*.ex
    # Public proof replay uses an independently compiled, pinned trusted Lynx.
    cp -R /trusted/lynx /tool/lynx
    cd /tool/lynx
    mix compile --warnings-as-errors
    ;;
  build)
    exec elixir -pa /tool/capture /trusted/driver/build.exs
    ;;
  inspect)
    exec elixir -pa /tool/capture /trusted/driver/inspect.exs
    ;;
  *) exit 64 ;;
esac
