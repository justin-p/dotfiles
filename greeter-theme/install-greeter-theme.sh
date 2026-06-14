#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WALLPAPER_SRC="$DOTFILES_DIR/cosmic-theme/bearded-gold-d-raynh-bg.png"
WALLPAPER_DEST="/usr/share/backgrounds/bearded-gold-d-raynh-bg.png"
GREETER_CONFIG="/var/lib/cosmic-greeter/.config/cosmic"
TARGET_USER="${SUDO_USER:-${USER:-justin-p}}"
USER_COSMIC="/home/$TARGET_USER/.config/cosmic"

THEME_COMPONENTS=(
  "com.system76.CosmicTheme.Mode"
  "com.system76.CosmicTheme.Dark"
  "com.system76.CosmicTheme.Dark.Builder"
)

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "error: run with sudo" >&2
  exit 1
fi

if [[ ! -f "$WALLPAPER_SRC" ]]; then
  echo "error: wallpaper not found: $WALLPAPER_SRC" >&2
  exit 1
fi

if [[ ! -d "$USER_COSMIC" ]]; then
  echo "error: user cosmic config not found: $USER_COSMIC" >&2
  exit 1
fi

install -D -m 0644 "$WALLPAPER_SRC" "$WALLPAPER_DEST"

install -d -m 0755 "$GREETER_CONFIG"
for component in "${THEME_COMPONENTS[@]}"; do
  if [[ -d "$USER_COSMIC/$component" ]]; then
    rm -rf "$GREETER_CONFIG/$component"
    cp -a "$USER_COSMIC/$component" "$GREETER_CONFIG/$component"
  fi
done

install -d -m 0755 "$GREETER_CONFIG/com.system76.CosmicBackground/v1"
cat >"$GREETER_CONFIG/com.system76.CosmicBackground/v1/all" <<EOF
(
    output: "all",
    source: Path("$WALLPAPER_DEST"),
    filter_by_theme: false,
    rotation_frequency: 900,
    filter_method: Lanczos,
    scaling_mode: Zoom,
    sampling_method: Alphanumeric,
)
EOF

chown -R cosmic-greeter:cosmic-greeter /var/lib/cosmic-greeter/.config

USER_BG="$USER_COSMIC/com.system76.CosmicBackground/v1/all"
if [[ -f "$USER_BG" ]]; then
  install -d -m 0755 "/home/$TARGET_USER/.config/cosmic/com.system76.CosmicBackground/v1"
  cat >"$USER_BG" <<EOF
(
    output: "all",
    source: Path("$WALLPAPER_DEST"),
    filter_by_theme: false,
    rotation_frequency: 900,
    filter_method: Lanczos,
    scaling_mode: Zoom,
    sampling_method: Alphanumeric,
)
EOF
  chown "$TARGET_USER:$TARGET_USER" "$USER_BG"
fi

for unit in cosmic-greeter-daemon.service cosmic-greeter.service; do
  if systemctl list-unit-files "$unit" >/dev/null 2>&1; then
    systemctl restart "$unit" || true
  fi
done

echo "installed greeter theme for cosmic-greeter and updated $TARGET_USER background path"
echo "wallpaper: $WALLPAPER_DEST"
