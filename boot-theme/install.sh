#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "error: run with sudo" >&2
  exit 1
fi

"$SCRIPT_DIR/plymouth/install.sh"
"$SCRIPT_DIR/greeter/install.sh"
