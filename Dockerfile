# Multi-stage build for Obsidian Level Maker (console-only / headless)
# Generates WAD files for Doom and other classic FPS games

# ============================================================
# Stage 1: Build
# ============================================================
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    ninja-build \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN cmake -B build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCONSOLE_ONLY=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/obsidian \
    && cmake --build build --parallel "$(nproc)"

# Install to a clean prefix
RUN cmake --install build --prefix /opt/obsidian

# ============================================================
# Stage 2: Runtime
# ============================================================
FROM debian:bookworm-slim AS runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r obsidian && useradd -r -g obsidian -m -d /home/obsidian obsidian

# Install Obsidian
COPY --from=builder /opt/obsidian /opt/obsidian

# Create output directory for generated WADs
RUN mkdir -p /wads && chown obsidian:obsidian /wads

# Create config directory for user-supplied configuration
RUN mkdir -p /config && chown obsidian:obsidian /config

WORKDIR /opt/obsidian

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER obsidian

VOLUME ["/wads", "/config"]

ENTRYPOINT ["docker-entrypoint.sh"]
# Default: generate a single WAD with default settings
CMD ["--batch", "/wads/output.wad"]
