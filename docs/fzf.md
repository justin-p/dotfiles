# fzf

fzf shell integration for bash and zsh (completion and key bindings).

## Install (stow)

```bash
cd ~/.dotfiles
stow fzf
```

Symlinks `~/.fzf.zsh`, `~/.fzf.bash`, and `~/.local/bin/fzf-bat-preview` (bat file preview for Ctrl+T / fzf-tab).

Pair with `zsh` for Bearded Gold fzf colors in Cursor / COSMIC Terminal — see [cosmic-term.md](cosmic-term.md).

## Preview

| Trigger | Preview |
|---------|---------|
| **Ctrl+T** | bat preview in a right-hand pane (`FZF_CTRL_T_OPTS`) |
| **Tab** on a file path | bat preview via fzf-tab |

Preview only shows for **files** (not directories). Toggle the pane with **?** if hidden.

```bash
# Manual fzf with preview
fd --hidden --follow --exclude .git | fzf --preview-window=right:55% --preview='fzf-bat-preview {}'
```

## Main files

- `~/.fzf.zsh`
- `~/.fzf.bash`

## Gotchas

- Paths assume fzf is installed at `~/.fzf` (cloned automatically by `zsh/.zshrc` on first login if missing).
- `zsh/.zshrc` sets `FZF_DEFAULT_OPTS` (`--height 70%`, `--min-height 15+`), `FZF_TMUX_HEIGHT`, theme colors, `FZF_DEFAULT_COMMAND` (`fd` or `fdfind` when installed, else `find .`), and bat-powered `FZF_CTRL_T_OPTS` when bat is installed — see [bat.md](bat.md).
