# Qualified platform: linux/arm64. The bootstrap context contains only the
# verified Lean and Hex source archives; see docs/verification/foundation.md.
FROM hexpm/elixir@sha256:40a7b841481b948902f293c042089d9e1c30498b123db1650f900c298c51cc4e

RUN apt-get update && apt-get install -y --no-install-recommends \
      bubblewrap ca-certificates git zstd coreutils \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/user
COPY lean-linux.tar.zst /tmp/lean-linux.tar.zst
RUN echo 'c8f0f8a3920e839718b1343e6781fd80a3e9b1024fbcd7078eb30f54e806b028  /tmp/lean-linux.tar.zst' \
      | sha256sum -c - \
    && mkdir /opt/lean \
    && tar --zstd -xf /tmp/lean-linux.tar.zst --strip-components=1 -C /opt/lean \
    && rm /tmp/lean-linux.tar.zst
# Hex's published OTP-old archive is not loadable on OTP 29; build the
# unchanged, pinned release source using the actual qualified BEAM compiler.
COPY hex-source.tar.gz /tmp/hex-source.tar.gz
RUN echo 'f248381ceb4bef12c990b223a7f998113b1997cb58d29b9883b7d03a0b990f9e  /tmp/hex-source.tar.gz' \
      | sha256sum -c - \
    && mkdir /tmp/hex-source \
    && tar -xf /tmp/hex-source.tar.gz --strip-components=1 -C /tmp/hex-source \
    && cd /tmp/hex-source \
    && MIX_ENV=prod MIX_HOME=/opt/mix mix archive.build -o /tmp/hex.ez \
    && MIX_HOME=/opt/mix mix archive.install /tmp/hex.ez --force \
    && rm -rf /tmp/hex-source /tmp/hex-source.tar.gz /tmp/hex.ez
ENV MIX_ARCHIVES=/opt/mix/archives \
    PATH="/opt/lean/bin:${PATH}" \
    HOME=/scratch/home \
    MIX_HOME=/scratch/home/.mix \
    HEX_HOME=/scratch/home/.hex \
    MIX_ENV=prod \
    ERL_FLAGS="+S 4:4"
WORKDIR /scratch
USER 1000:1000
