# dotfiles

Used by https://github.com/justin-p/Setup-My-W10-Machine and https://github.com/justin-p/ansible-my-linux-workstation

## Packages

**Stow** (`cd ~/.dotfiles && stow <name>`) symlinks config into `$HOME`. **Install** packages use scripts; **Manual** packages are source files or copy-paste setup.

| Package | Type | Doc |
|---------|------|-----|
| bash | Stow | [docs/bash.md](docs/bash.md) |
| boot-theme | Install | [docs/boot-theme.md](docs/boot-theme.md) |
| BurpSuite | Stow | [docs/burpsuite.md](docs/burpsuite.md) |
| cosmic-term | Stow | [docs/cosmic-term.md](docs/cosmic-term.md) |
| cosmic-theme | Manual | [docs/cosmic-theme.md](docs/cosmic-theme.md) |
| cursor-sync | Stow | [docs/cursor-sync.md](docs/cursor-sync.md) |
| fan_control | Manual | [docs/fan-control.md](docs/fan-control.md) |
| firefox | Stow + script | [docs/firefox.md](docs/firefox.md) |
| flameshot | Stow | [docs/flameshot.md](docs/flameshot.md) |
| fzf | Stow | [docs/fzf.md](docs/fzf.md) |
| git | Stow | [docs/git.md](docs/git.md) |
| htop | Stow | [docs/htop.md](docs/htop.md) |
| nano | Stow | [docs/nano.md](docs/nano.md) |
| Powershell | Windows | [docs/powershell.md](docs/powershell.md) |
| smb | Stow | [docs/smb.md](docs/smb.md) |
| spaceship | Stow | [docs/spaceship.md](docs/spaceship.md) |
| ssh-sync | Stow | [docs/ssh-sync.md](docs/ssh-sync.md) |
| tmux | Stow | [docs/tmux.md](docs/tmux.md) |
| ulauncher | Stow | [docs/ulauncher.md](docs/ulauncher.md) |
| vim | Stow | [docs/vim.md](docs/vim.md) |
| wallpaper | Manual | [docs/wallpaper.md](docs/wallpaper.md) |
| zsh | Stow | [docs/zsh.md](docs/zsh.md) |

Windows setup: [docs/windows.md](docs/windows.md) (`bootstrap.ps1`, `update.ps1`).

## Modern CLI tooling

Primary shell is **zsh** ([docs/zsh.md](docs/zsh.md)). Bash aliases ([docs/bash.md](docs/bash.md)) apply when you source `~/.bash_aliases` from a non-zsh session.

### Bash - hard replacements (`bash/.bash_aliases`)

| Command | Routed to | Requires |
|---------|-----------|----------|
| `ls` | [lsd](https://github.com/lsd-rs/lsd) | `lsd` on `PATH` |
| `cat` | [bat](https://github.com/sharkdp/bat) | `bat` on `PATH` |
| `grep` | [rg](https://github.com/BurntSushi/ripgrep) | `rg` on `PATH` |

### Zsh - replacements (`zsh/.zsh_alias`)

| Command | Routed to | Requires |
|---------|-----------|----------|
| `cat` | `ccat` (OMZ colorize) | `pygmentize` or `chroma` |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) `z` | `zoxide` on `PATH` |
| `git commit` / `git add` | [better-commits](https://github.com/pvande/better-commits) | `npm` |

### Zsh - warn only (still runs the original command)

Prints `Consider using <tool> instead.` when the modern tool is installed. Defined in `zsh/.zsh_alias`; needs the optional tool on `PATH`.

| Command | Suggests | Requires |
|---------|----------|----------|
| `df` | `duf` | [duf](https://github.com/muesli/duf) |
| `htop` | `btop` | [btop](https://github.com/aristocratos/btop) |
| `find` | `fd` or `fdfind` | [fd](https://github.com/sharkdp/fd) (`fdfind` on Debian/Ubuntu) |

### Zsh - fzf file source (`zsh/.zshrc`)

| Setting | Uses `fd` / `fdfind` | Fallback |
|---------|----------------------|----------|
| `FZF_DEFAULT_COMMAND` | `fd --hidden --follow --exclude .git` | `find .` |

See [docs/fzf.md](docs/fzf.md).

### Git - pager ([docs/git.md](docs/git.md))

| Command | Pager | Fallback |
|---------|-------|----------|
| `git diff`, `git show` | [delta](https://github.com/dandavison/delta) via `~/.local/bin/git-pager-delta` | `less -FRX` |
| interactive rebase diffs | delta `--color-only` (same wrapper) | `cat` |

`stow git` symlinks the pager script and [Bearded Theme feat. Gold D Raynh](docs/cosmic-term.md) delta colors (`git/.delta-themes.gitconfig`).

### Agent / IDE shells

Zsh wrappers above are **disabled** under `CURSOR_AGENT` / `CURSOR_TRACE` (plain `command` / `builtin` behavior). The OMZ **git** plugin plus **zsh-you-should-use** also nudge toward short aliases (e.g. `gd` instead of `git diff`).
