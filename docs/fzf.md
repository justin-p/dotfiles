# fzf

fzf shell integration for bash and zsh (completion and key bindings).

## Install (stow)

```bash
cd ~/.dotfiles
stow fzf
```

Pair with `zsh` for Bearded Gold fzf colors in Cursor / COSMIC Terminal — see [cosmic-term.md](cosmic-term.md).

## Main files

- `~/.fzf.zsh`
- `~/.fzf.bash`

## Gotchas

- Paths assume fzf is installed at `~/.fzf` (cloned automatically by `zsh/.zshrc` on first login if missing).
- `zsh/.zshrc` also sets `FZF_DEFAULT_OPTS`, theme colors, and `FZF_DEFAULT_COMMAND` (`fd` or `fdfind` when installed, else `find .`).
