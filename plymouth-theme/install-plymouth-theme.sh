#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="bearded-gold"
THEME_SRC="$SCRIPT_DIR/$THEME_NAME"
THEME_DEST="/usr/share/plymouth/themes/$THEME_NAME"
ALT_LINK="/usr/share/plymouth/themes/default.plymouth"
ALT_NAME="default.plymouth"
PRIORITY=210

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "error: run with sudo" >&2
  exit 1
fi

if [[ ! -f "$THEME_SRC/$THEME_NAME.plymouth" ]]; then
  echo "generating assets..." >&2
  python3 "$SCRIPT_DIR/generate-assets.py"
fi

install -d "$THEME_DEST"
cp -a "$THEME_SRC/." "$THEME_DEST/"

if ! update-alternatives --query "$ALT_NAME" >/dev/null 2>&1; then
  echo "error: $ALT_NAME alternatives group missing" >&2
  exit 1
fi

if update-alternatives --list "$ALT_NAME" | grep -qxF "$THEME_DEST/$THEME_NAME.plymouth"; then
  :
else
  update-alternatives --install "$ALT_LINK" "$ALT_NAME" "$THEME_DEST/$THEME_NAME.plymouth" "$PRIORITY"
fi

update-alternatives --set "$ALT_NAME" "$THEME_DEST/$THEME_NAME.plymouth"

echo "rebuilding initramfs..."
update-initramfs -u -k all

if command -v kernelstub >/dev/null 2>&1; then
  kernelstub
fi

echo "installed $THEME_NAME Plymouth theme"
echo "preview: sudo plymouthd && sudo plymouth --show-splash && sleep 5 && sudo plymouth quit"
