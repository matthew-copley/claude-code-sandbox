FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      git ca-certificates curl less jq ripgrep zsh \
    && rm -rf /var/lib/apt/lists/*

# UID 1000 so bind-mounted files keep sane ownership on Linux hosts.
RUN userdel -r node 2>/dev/null || true; \
    groupadd -g 1000 claude && \
    useradd -u 1000 -g 1000 -m -s /usr/bin/zsh claude

RUN npm install -g @anthropic-ai/claude-code && npm cache clean --force

# Install uv binary from official image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_PYTHON_INSTALL_DIR=/opt/uv/python
RUN uv python install 3.12 && chmod -R a+rX /opt/uv

# Create this before the volume mounts over it. Docker seeds an empty named
# volume from the image path and preserves ownership, so claude-config ends up
# writable by uid 1000 instead of root-owned and unwritable.
RUN mkdir -p /home/claude/.claude && chown -R claude:claude /home/claude

USER claude
WORKDIR /workspace
ENV HOME=/home/claude \
    SHELL=/usr/bin/zsh \
    CLAUDE_CONFIG_DIR=/home/claude/.claude \
    UV_PYTHON_INSTALL_DIR=/opt/uv/python