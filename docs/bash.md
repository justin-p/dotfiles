# Bash aliases

Bash aliases for modern CLI tools and SSH shortcuts. Does not include a `.bashrc` — source `~/.bash_aliases` from your existing bash config if needed.

## Install (stow)

```bash
cd ~/.dotfiles
stow bash
```

## Aliases

| Alias | Command |
|-------|---------|
| `ls` | `eza --icons=always --group-directories-first` |
| `cat` | `bat --paging=never` or `batcat --paging=never` — see [bat.md](bat.md) |
| `grep` | `rg` |
| `ii` | `xdg-open` |
| `ssh-add` | `ssh-add -t 1h` |
| `firefox-dev` | `~/tools/firefox/firefox` |

Also includes SSH tunnel shortcuts (`stepstone`, `shellserver`) and `ansible-galaxy-api`.
