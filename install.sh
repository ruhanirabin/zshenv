#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2026 Ruhani Rabin (Rabin)
# =============================================================================
# install.sh — Bootstrap installer for zshenv
# =============================================================================
# Downloads the latest release and runs bin/zshenv-install.
# Forward all arguments to zshenv-install.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION_FILE="${SCRIPT_DIR}/VERSION"

echo "zshenv bootstrap installer"

# Validate required files exist
for f in VERSION bin/zshenv-install; do
  if [[ ! -f "$SCRIPT_DIR/$f" ]]; then
    echo "ERR: Missing required file: $f"
    echo "Ensure you are running from the zshenv repo root."
    exit 1
  fi
done

# Validate SemVer
VERSION="$(tr -d '[:space:]' < "$VERSION_FILE")"
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "ERR: VERSION file does not contain valid SemVer: $VERSION"
  exit 1
fi

echo "Version: $VERSION"
echo ""

# Run the main installer with all forwarded arguments
chmod +x "$SCRIPT_DIR/bin/zshenv-install"
exec "$SCRIPT_DIR/bin/zshenv-install" "$@"
