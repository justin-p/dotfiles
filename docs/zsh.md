# Zsh

Primary shell: antidote plugin bundle, fzf/fzf-tab theming, PATH setup, fnm, Rust/cargo, Bun, and zoxide.

## Install (stow)

```bash
cd ~/.dotfiles
stow zsh
stow spaceship fzf git    # recommended companions
```

Pair with `cosmic-term` for matching fzf colors — see [cosmic-term.md](cosmic-term.md).

## Main files

| File | Purpose |
|------|---------|
| `~/.zshrc` | Shell init, PATH, fzf theme, fnm/cargo/bun/zoxide |
| `~/.zsh_plugins` | antidote plugin list |
| `~/.zsh_alias` | Custom aliases and wrappers (`cat`, `git`, `cd`, `df`, `htop`, `find`) |

## First login

`~/.zshrc` may auto-clone on first run:

- [antidote](https://github.com/mattmc3/antidote) → `~/.antidote`
- [fzf](https://github.com/junegunn/fzf) → `~/.fzf`
- [tmux TPM](https://github.com/tmux-plugins/tpm) → `~/.tmux/plugins/tpm`

## Tooling in `~/.zshrc`

- **fnm** — `~/.local/share/fnm` on `PATH` + `fnm env` (not the OMZ fnm plugin).
- **cargo** — `~/.cargo/bin` on `PATH`; sources `~/.cargo/env` when present.
- **zoxide** — `eval "$(zoxide init zsh)"` after cargo (zoxide is often installed via `cargo install`).
- **fzf** — `FZF_DEFAULT_COMMAND` uses `fd` or `fdfind` when installed, else `find .`.

## Wrappers in `~/.zsh_alias`

| Wrapper | Behavior |
|---------|----------|
| `cat` | Uses OMZ `colorize` (`ccat`) when available; needs `pygmentize` or `chroma` |
| `git` | Routes `commit` / `add` through `better-commits` |
| `cd` | Uses zoxide `z` when available |
| `df` | Warns `Consider using duf instead.` when duf is installed; still runs plain `df` |
| `htop` | Warns `Consider using btop instead.` when btop is installed; still runs plain `htop` |
| `find` | Warns `Consider using fd/fdfind instead.` when installed; still runs plain `find` |

Wrappers fall back to plain builtins/commands under `CURSOR_AGENT` / `CURSOR_TRACE`.

## Gotchas

- Some paths are user-specific (`/home/justin-p/...`).
- `better-commits`, `zoxide`, `cat`, `df`, `htop`, and `find` wrappers are disabled under `CURSOR_AGENT` / `CURSOR_TRACE`.
- Install [duf](https://github.com/muesli/duf) for the `df` wrapper; without it, plain `df` is unchanged.
- Install [btop](https://github.com/aristocratos/btop) for the `htop` wrapper; without it, plain `htop` is unchanged.
- Install [fd](https://github.com/sharkdp/fd) for faster fzf search and the `find` wrapper (`fdfind` on Debian/Ubuntu); without it, fzf falls back to `find .`.
- Install [zoxide](https://github.com/ajeetdsouza/zoxide) separately if you want the `cd` wrapper; it is not an antidote plugin.
- `nvm` is still sourced from `~/.zshrc` if present alongside fnm.
