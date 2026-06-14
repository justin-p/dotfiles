# COSMIC desktop theme — Bearded Theme feat. Gold D Raynh

Desktop/window-manager theme matching Bearded Theme feat. Gold D Raynh (VS Code / Cursor): navy surfaces, gold accent, compact spacing, 2px corners.

This package is not stowed

## Import via Settings

**Settings → Appearance → Import** → `~/.dotfiles/cosmic-theme/bearded-gold-d-raynh.ron`

Use this if live config did not refresh, or on a new machine before running the script.

## Wallpaper

Solid `#0e1424` wallpaper (matches terminal/panel background):

```
~/.dotfiles/cosmic-theme/bearded-gold-d-raynh-bg.png
```

Point COSMIC background at it in `~/.config/cosmic/com.system76.CosmicBackground/v1/all`:

```ron
source: Path("/home/justin-p/.dotfiles/cosmic-theme/bearded-gold-d-raynh-bg.png"),
filter_by_theme: false,
```

Restart `cosmic-bg` or log out/in if the wallpaper does not update.

## Layout settings (from exported dark theme)

| Setting | Value |
|---------|-------|
| Corner radii | 2px (all sizes) |
| Spacing | compact (4/8/16…) |
| Gaps | `(0, 8)` |
| Active hint | `3` |
| Frosted | `false` |

## Key colors

| Role | Hex |
|------|-----|
| Desktop / wallpaper | `#0e1424` |
| Main background | `#0f1628` |
| Deep chrome | `#0c1220` |
| Containers | `#16203b` / `#1a2137` |
| Text | `#b8c4e4` |
| Accent / window hint | `#e39000` |
| Success / warning / destructive | `#21ff7d` / `#ff823f` / `#f7775a` |

## Files

```
cosmic-theme/
  apply-bearded-theme.py
  bearded-gold-d-raynh.ron
  bearded-gold-d-raynh-bg.png
```

## Boot splash and login screen

Plymouth boot splash and COSMIC greeter can match this theme. See [boot-theme.md](boot-theme.md).

## Troubleshooting

**Theme unchanged after script** — import the `.ron` via Settings, or toggle dark mode off/on.

**Wallpaper still default nebula** — edit `com.system76.CosmicBackground/v1/all` directly; the Settings wallpaper picker can fail to apply custom images on some COSMIC builds.

**Terminal colors differ from desktop** — terminal scheme is a separate package; see [cosmic-term.md](cosmic-term.md). Desktop `bg_color` intentionally uses `#0e1424` to align with the terminal background, not editor `#0f1628`.

**`cosmic-ctl` not required** — the apply script writes RON config files directly.
