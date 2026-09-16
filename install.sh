#!/usr/bin/env bash
# Keep shell options, directory changes, and exits inside a subshell.
(
set -euo pipefail

# Run from the project directory even when invoked from elsewhere.
viki_project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$viki_project_dir"

if ! command -v uv >/dev/null 2>&1; then
    echo "uv not found. Installing uv..."
    viki_uv_dir="${UV_INSTALL_DIR:-$HOME/.local/bin}"

    if command -v curl >/dev/null 2>&1; then
        curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="$viki_uv_dir" sh
    elif command -v wget >/dev/null 2>&1; then
        wget -qO- https://astral.sh/uv/install.sh | UV_INSTALL_DIR="$viki_uv_dir" sh
    else
        echo "Error: curl or wget is required to install uv." >&2
        exit 1
    fi

    # Make the newly installed uv available in this shell immediately.
    export PATH="$viki_uv_dir:$PATH"
fi

if ! command -v uv >/dev/null 2>&1; then
    echo "Error: uv is unavailable after installation." >&2
    exit 1
fi

echo "Starting viki-harness..."
uv run viki-harness "$@"
)
