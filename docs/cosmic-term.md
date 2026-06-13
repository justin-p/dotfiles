# COSMIC Terminal — Bearded Theme feat. Gold D Raynh

Terminal color scheme matching Bearded Theme feat. Gold D Raynh.

## Install (stow)

```bash
cd ~/.dotfiles
stow cosmic-term
```

Also stow `zsh` if you want matching **fzf** / **fzf-tab** colors when this scheme is active in COSMIC Terminal.

## Activate the scheme

**Settings UI:** COSMIC Terminal → Appearance → Color scheme → **Bearded Theme feat. Gold D Raynh**

**Or** set the active dark syntax theme directly:

```bash
echo '"Bearded Theme feat. Gold D Raynh"' > \
  ~/.config/cosmic/com.system76.CosmicTerm/v1/syntax_theme_dark
```

Restart the terminal or open a new tab.

## fzf integration (zsh)

When COSMIC Terminal is the parent process and the active scheme is **Bearded Theme feat. Gold D Raynh**, `~/.dotfiles/zsh/.zshrc` applies Gold D Raynh `FZF_DEFAULT_OPTS` (same palette as Cursor integrated terminal).

Detection reads theme from:

- `~/.config/cosmic/com.system76.CosmicTerm/v1/syntax_theme_dark`
- `syntax_theme_light` / `profiles` (fallback)

## Key colors

| Role | Hex |
|------|-----|
| Background | `#0e1424` |
| Foreground | `#b8c4e4` |
| Cursor | `#ffd000` |
| Red / green / yellow / blue | `#f7775a` / `#21ff7d` / `#ffd000` / `#3eb2ff` |

## Files

```
cosmic-term/
  .config/cosmic-term/color-schemes/
    Bearded Theme feat. Gold D Raynh.ron
```

Live selection is stored under `~/.config/cosmic/com.system76.CosmicTerm/v1/` (not stowed).

## Troubleshooting

**Scheme missing in picker** — re-run `stow cosmic-term` and confirm the file exists at `~/.config/cosmic-term/color-schemes/Bearded Theme feat. Gold D Raynh.ron`.

**fzf still uses Tango colors** — open a new shell in COSMIC Terminal with this scheme selected. fzf only switches when the parent process is `cosmic-term` and the theme name matches exactly.

**Stale Stained Blue name** — remove any old `Bearded Theme Stained Blue.ron` copies under `~/.config/cosmic-term/color-schemes/` if they were left from an earlier setup.
