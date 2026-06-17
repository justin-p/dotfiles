# fzf

fzf shell integration for bash and zsh (completion and key bindings).

## Install (stow)

```bash
cd ~/.dotfiles
stow fzf
```

Symlinks `~/.fzf.zsh`, `~/.fzf.bash`, and `~/.local/bin/fzf-file-preview`.

### Optional preview tools

Installed via apt when missing — `130-optional-deps.zsh` runs `dotfiles-optional-deps-check` once per day. Example apt line:

```bash
sudo apt install chafa poppler-utils mupdf-tools ffmpegthumbnailer atool exiftool mediainfo
```

Note: the `mutool` binary comes from **`mupdf-tools`** (not a package named `mutool`). `exiftool` is the apt-friendly name for `libimage-exiftool-perl`.

Full package list (bat, fd-find, eza, delta, …): see [zsh.md](zsh.md#optional-apt-tools).

| Type | Tool | Fallback |
|------|------|----------|
| Images / GIF | chafa | `file` |
| Markdown | bat | cat |
| PDF | pdftoppm → chafa | mutool → chafa, then `file` |
| Archives | atool -l | unzip -l / tar -tf |
| Video | ffmpegthumbnailer → chafa | exiftool / mediainfo |
| Git directory | git log + eza tree | ls |
| Binary | exiftool / mediainfo | `file` |
| Text | bat | cat |

Pair with `zsh` for Bearded Gold fzf colors in Cursor / COSMIC Terminal — see [cosmic-term.md](cosmic-term.md).

## Preview

| Trigger | Preview |
|---------|---------|
| **Ctrl+T** | `fzf-file-preview` in a right-hand pane (`FZF_CTRL_T_OPTS`) |
| **Tab** on a path | file/dir preview via `fzf-file-preview` |
| **Tab** on `man …` | man page (bat via `MANPAGER`) |
| **Tab** on `kill …` | process command line (`ps`; preview below) |
| **Tab** on `git …` | diff/log/show via delta; `git help` via bat |

**GIFs:** first frame only (`chafa --animate=off` on chafa ≥ 1.12; older apt chafa uses `-d 0 --zoom`).

**Image quality:** Kitty/Ghostty and iTerm2 get sharp pixel previews. **COSMIC Terminal** and **Cursor/VS Code** use Unicode block art. Override with `FZF_PREVIEW_IMAGE_FORMAT=iterm|kitty|sixels|symbols`.

```bash
fd --hidden --follow --exclude .git | fzf --preview-window=right:55% --preview='fzf-file-preview {}'
```

## Main files

- `~/.fzf.zsh`
- `~/.fzf.bash`
- `~/.local/bin/fzf-file-preview`

## Gotchas

- Paths assume fzf is installed at `~/.fzf` (cloned automatically by `zsh/.zshrc` on first login if missing).
- `zsh/.zshrc` sets `FZF_DEFAULT_OPTS`, `FZF_TMUX_HEIGHT`, theme colors, `FZF_DEFAULT_COMMAND` (`fd` / `fdfind`), and `FZF_CTRL_T_OPTS` — see [bat.md](bat.md).
- Missing optional tools degrade gracefully to bat or `file`.
