# bat

[syntax-highlighted cat](https://github.com/sharkdp/bat) — used as `cat`, `man` pager, and fzf preview.

## Install

```bash
sudo apt install bat    # binary is batcat on Debian/Ubuntu
stow bat                  # theme + config → ~/.config/bat/
batcat cache --build      # register custom theme (once after stow)
```

## Theme

**Bearded Theme feat. Gold D Raynh** — custom bat theme matching [cosmic-term](cosmic-term.md), [fzf](fzf.md), and [eza](eza.md) palettes.

| File | Purpose |
|------|---------|
| `~/.config/bat/config` | Default `--theme="Bearded-Gold-D-Raynh"` |
| `~/.config/bat/themes/Bearded-Gold-D-Raynh.tmTheme` | Syntax colors (derived from TwoDark, recolored) |

Zsh sets `BAT_THEME` to match the active terminal: Bearded in COSMIC Terminal / Cursor / VS Code, `TwoDark` elsewhere (same logic as fzf colors in `~/.zshrc`).

## Shell integration

| Integration | Shell | Behavior |
|-------------|-------|----------|
| `cat` | zsh, bash | `bat --paging=never` / `batcat --paging=never` when installed |
| `bat` alias | zsh, bash | `batcat` → `bat` on Debian/Ubuntu |
| `man` | zsh, bash | `MANPAGER="bat -plman"` (replaces OMZ `colored-man-pages`) |
| `--help` | zsh | Global alias pipes any `cmd --help` through bat; use `chelp` for explicit calls |
| `--help` | bash | `chelp cmd` |
| fzf Ctrl+T | zsh, bash | `FZF_CTRL_T_OPTS` + `fzf-file-preview` (bat, chafa, PDF/video, archives) |
| fzf-tab | zsh | Path completion preview via `fzf-file-preview` |
| `git diff` / `git show` | — | [delta](git.md) pager instead (better than bat for diffs) |

Zsh detects `bat` or `batcat` via `_BAT_CMD` in `~/.zshrc` (same pattern as `_FD_CMD` for `fd`/`fdfind`).

```bash
man --help            # zsh: auto via global alias
chelp docker          # explicit, works in bash too
```

Zsh expands `--help` to `--help 2>&1 | bathelp` everywhere via a global alias (`alias -g`). Wrappers that add extra flags (`eza`, `git`, `ls`) detect `--help` and pass it through unchanged first.

We do **not** alias `-h` globally (`ls -h` is human-readable sizes). Ubuntu's zsh 5.9 has no `abbr` module.

### Manual git show (optional)

Delta handles `git diff` and `git show` pager output. To syntax-highlight a file at a specific revision:

```bash
git show v1.0.0:src/main.rs | bat -l rs
```

## Gotchas

- `cat` wrapper is disabled under `CURSOR_AGENT` / `CURSOR_TRACE` (zsh only); `MANPAGER` and fzf previews are always on when bat is installed.
- fzf preview: bat for text (500-line cap), **chafa** for images (`sudo apt install chafa`). Kitty/Ghostty use `kitten icat` when available.
- Preview pane is on the **right** (55% width). Press **?** in fzf to toggle preview if hidden.
- `stow fzf` installs `~/.local/bin/fzf-file-preview`; re-run if preview says command not found.
- On Debian/Ubuntu the package installs `batcat`; dotfiles alias it to `bat`.
