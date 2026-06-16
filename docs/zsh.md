# Zsh

Primary shell: antidote plugin bundle, fzf/fzf-tab theming, PATH setup, fnm, Rust/cargo, Bun, and zoxide.

## Install (stow)

```bash
cd ~/.dotfiles
stow zsh
stow spaceship fzf git eza    # recommended companions
```

Pair with `cosmic-term` for matching fzf colors — see [cosmic-term.md](cosmic-term.md).

## Main files

| File | Purpose |
|------|---------|
| `~/.zshrc` | Shell init, PATH, fzf theme, fnm/cargo/bun/zoxide |
| `~/.zsh_plugins` | antidote plugin list |
| `~/.zsh_alias` | Custom aliases and wrappers (`cat`, `git`, `cd`, `df`, `htop`, `find`, `ping`, `ls`, `eza`) |

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
- **fzf-tab** — previews for paths (`fzf-file-preview`), `man`, `kill`/`ps`, git (delta/bat), and docker containers. See [fzf.md](fzf.md).

## Wrappers in `~/.zsh_alias`

| Wrapper | Behavior |
|---------|----------|
| `cat` | [bat](https://github.com/sharkdp/bat) with `--paging=never` when installed (`batcat` on Debian/Ubuntu); else plain `cat` — see [bat.md](bat.md) |
| `chelp` | Colorized `cmd --help` via bat when installed |
| `git` | Routes `commit` / `add` through `better-commits` |
| `cd` | Uses zoxide `z` when available |
| `df` | Warns `Consider using duf instead.` when duf is installed; still runs plain `df` |
| `htop` | Warns `Consider using btop instead.` when btop is installed; still runs plain `htop` |
| `find` | Warns `Consider using fd/fdfind instead.` when installed; still runs plain `find` |
| `ping` | Warns to use `gping` and/or `mtr` when installed; still runs plain `ping` |
| `ls` | Warns `Consider using eza instead.` when eza is installed; still runs plain `ls` |
| `eza` | Adds `--icons=auto --group-directories-first -Alh --git --header`; auto-ignores SMB mounts from `~/.config/smb/*.env`; tree mode (`-T`) also ignores `.git` — see [eza.md](eza.md) |

Wrappers fall back to plain builtins/commands under `CURSOR_AGENT` / `CURSOR_TRACE`.

## Optional apt tools

On interactive startup (once per day), `dotfiles-optional-deps-check` warns if recommended tools are missing. It checks binaries on `PATH` (and `~/.fzf/bin/fzf`), suggests `sudo apt install …` only for packages available in your apt repos, and prints separate hints for non-apt installs (e.g. `mupdf-tools` for `mutool`, `snap install gping`, `npm install -g better-commits`). Skipped under `CURSOR_AGENT` / `CURSOR_TRACE` and on non-Debian systems.

```bash
DOTFILES_OPTIONAL_DEPS_FORCE=1 dotfiles-optional-deps-check   # re-check now
```

Packages checked: `bat`, `fd-find`, `eza`, `git-delta`, `ripgrep`, `zoxide`, `fzf`, `chafa`, `poppler-utils`, `mupdf-tools` (`mutool`), `ffmpegthumbnailer`, `atool`, `exiftool` (`libimage-exiftool-perl`), `mediainfo`, `duf`, `btop`, `gping` (snap on Pop!_OS), `mtr-tiny`, `gh`, `better-commits` (npm). See [fzf.md](fzf.md) and [README.md](../README.md) for what each enables.

## Gotchas

- Some paths are user-specific (`/home/justin-p/...`).
- `better-commits`, `zoxide`, `cat`, `df`, `htop`, `find`, `ping`, and `ls` wrappers are disabled under `CURSOR_AGENT` / `CURSOR_TRACE`.
- Install [duf](https://github.com/muesli/duf) for the `df` wrapper; without it, plain `df` is unchanged.
- Install [btop](https://github.com/aristocratos/btop) for the `htop` wrapper; without it, plain `htop` is unchanged.
- Install [fd](https://github.com/sharkdp/fd) for faster fzf search and the `find` wrapper (`fdfind` on Debian/Ubuntu); without it, fzf falls back to `find .`.
- Install [gping](https://github.com/orf/gping) and/or `mtr` for the `ping` wrapper; without either, plain `ping` is unchanged.
- Install [eza](https://github.com/eza-community/eza) for the `ls` hint and `eza` wrapper; theme via `stow eza` — see [eza.md](eza.md). Pair with `stow smb` so mount ignores match your profiles.
- Install [zoxide](https://github.com/ajeetdsouza/zoxide) separately if you want the `cd` wrapper; it is not an antidote plugin.
- `nvm` is still sourced from `~/.zshrc` if present alongside fnm.
