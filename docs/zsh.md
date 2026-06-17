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
| `~/.zshenv` | Thin loader; sources `~/.zpath.zsh` |
| `~/.zpath.zsh` | PATH and toolchain setup (all shells + interactive fnm on `PATH`) |
| `~/.zshrc` | Thin loader; sources `~/.zshrc.d/*.zsh` in order |
| `~/.zshrc.d/*.zsh` | Modular init (history, antidote, fzf, PATH, deferred tooling) |
| `~/.zsh_plugins` | antidote plugin list |
| `~/.zsh_alias` | Thin loader; sources `~/.zsh_alias.d/*.zsh` |
| `~/.zsh_alias.d/*.zsh` | Aliases and command wrappers |
| `~/.local/bin/dotfiles-lib.sh` | Shared `dotfiles_msg` formatter and sync detection |
| `~/.local/bin/dotfiles-sync-check` | Daily git/stow sync warning (via `125-dotfiles-sync.zsh`) |
| `~/.local/bin/dotfiles-sync-fix` | Apply stow / commit / pull / push fixes |
| `~/.local/bin/dotfiles-optional-deps-check` | Daily optional-tool warning (via `130-optional-deps.zsh`) |

### `~/.zshrc.d/` modules

| File | Purpose |
|------|---------|
| `10-history.zsh` | History options and history-here paths |
| `15-dotfiles-msg.zsh` | `_dotfiles_msg` shared stderr formatter |
| `20-completion.zsh` | `fpath`, menu completion |
| `30-antidote.zsh` | antidote clone; static `~/.zsh_plugins.zsh` bundle |
| `32-history-substring-search.zsh` | ↑/↓ history prefix search bindkeys |
| `35-compinit.zsh` | `compinit -C` with cached dump; scheduled full `compinit` rebuild |
| `40-history-here.zsh` | Per-project history under `Documents/_customers` |
| `50-tools.zsh` | `fd`/`bat` detection and bat cache |
| `55-zoxide.zsh` | `zoxide init` (before aliases) |
| `60-aliases.zsh` | Sources `~/.zsh_alias` (loads `~/.zsh_alias.d/*.zsh`) |
| `70-fzf-bootstrap.zsh` | fzf clone on first login |
| `80-fzf-theme.zsh` | fzf/bat theme (COSMIC, Cursor, VS Code) |
| `90-fzf-bindings.zsh` | fzf key bindings, `FZF_DEFAULT_COMMAND`, zoxide fzf opts (`_ZO_FZF_OPTS`) |
| `95-fzf-tab.zsh` | fzf-tab previews and completion zstyles |
| `110-deferred.zsh` | Deferred fnm/bun/cargo init (`romkatv/zsh-defer`) |
| `120-virtualenv.zsh` | `enable_autoswitch_virtualenv` |
| `125-dotfiles-sync.zsh` | Daily dotfiles git/stow sync check |
| `130-optional-deps.zsh` | Daily optional-deps check |

## Custom completions (`~/.zfunc`)

`fpath` includes `~/.zfunc` for machine-local completion functions. Drop a `_commandname` file there (e.g. `_mytool` for `mytool` tab completion). Not tracked in dotfiles — create the directory when needed:

```bash
mkdir -p ~/.zfunc
```

## First login

`~/.zshrc.d/` may auto-clone or generate on first run:

- [antidote](https://github.com/mattmc3/antidote) → `~/.antidote` (via `30-antidote.zsh`)
- Static plugin bundle → `~/.zsh_plugins.zsh` (regenerated when `~/.zsh_plugins` changes)
- [fzf](https://github.com/junegunn/fzf) → `~/.fzf` (via `70-fzf-bootstrap.zsh`)

TPM for tmux is installed separately — see [tmux.md](tmux.md).

## Tooling

- **fnm** — install to `~/.local/share/fnm` (install script or apt); `fnm install --lts` for Node. Binary on `PATH` via `~/.zpath.zsh`; `fnm env` deferred in `110-deferred.zsh` (Node/npm globals available right after the first prompt). Install globals with `npm install -g better-commits` (requires Node ≥ 20.19). Warned by optional-deps when missing.
- **bun** — `~/.bun/bin` on `PATH` in `~/.zpath.zsh`; `_bun` completion deferred in `110-deferred.zsh`.
- **cargo** — `~/.cargo/bin` on `PATH` in `~/.zpath.zsh`; `~/.cargo/env` deferred.
- **zoxide** — `eval "$(zoxide init zsh)"` in `55-zoxide.zsh`; `_ZO_FZF_OPTS` set in `90-fzf-bindings.zsh`.
- **fzf** — `FZF_DEFAULT_COMMAND` uses `fd` or `fdfind` when installed, else `find .`.
- **fzf-tab** — previews for paths (`fzf-file-preview`), `man`, `kill`/`ps`, git (delta/bat), and docker containers. See [fzf.md](fzf.md).
- **Deferred plugins** — `zsh-autosuggestions`, `fast-syntax-highlighting`, and `zsh-you-should-use` use antidote `kind:defer` (via `romkatv/zsh-defer`); they load when ZLE is idle after the prompt appears, not during non-interactive runs like `zsh -i -c exit`.

### `~/.zsh_alias.d/` modules

| File | Purpose |
|------|---------|
| `00-guards.zsh` | `_cursor_agent_shell`, `_prefer_tool_hint_skip` |
| `05-prefer-tool-hint.zsh` | `_prefer_tool_hint` → unified `dotfiles: consider using:` messages |
| `10-basic.zsh` | `ii`, dircolors, grep color aliases |
| `15-grep.zsh` | `grep` → `rg` hint when ripgrep installed (skipped while sourcing config) |
| `20-bat.zsh` | `cat`, `chelp`, `bathelp`, `--help` global alias |
| `30-git.zsh` | `git` better-commits wrapper, `gs` |
| `40-cd.zsh` | zoxide `cd` wrapper |
| `60-warn-wrappers.zsh` | `df`, `htop`, `find`, `ping` hints |
| `70-eza.zsh` | `eza` defaults and `ls` hint |

## Wrappers in `~/.zsh_alias.d/`

| Wrapper | Behavior |
|---------|----------|
| `cat` | [bat](https://github.com/sharkdp/bat) with `--paging=never` when installed (`batcat` on Debian/Ubuntu); else plain `cat` — see [bat.md](bat.md) |
| `chelp` | Colorized `cmd --help` via bat when installed |
| `git` | Bare `git commit` or bare `git add` (no args) → `better-commits` when installed; otherwise prefer-tool hint + install line + real git; all other git invocations pass through |
| `cd` | Uses zoxide `z` when available |
| `df` | `dotfiles: consider using: duf` when duf is installed; still runs plain `df` |
| `htop` | `dotfiles: consider using: btop` when btop is installed; still runs plain `htop` |
| `find` | `dotfiles: consider using: fd` or `fdfind` when installed; still runs plain `find` |
| `grep` | `dotfiles: consider using: rg` when ripgrep is installed; skipped during config sourcing; still runs plain `grep` |
| `ping` | `dotfiles: consider using: gping` and/or `mtr` when installed; still runs plain `ping` |
| `ls` | `dotfiles: consider using: eza` when eza is installed; still runs plain `ls` |
| `eza` | Adds `--icons=auto --group-directories-first -Alh --git --header`; auto-ignores SMB mounts from `~/.config/smb/*.env`; tree mode (`-T`) also ignores `.git` — see [eza.md](eza.md) |

Wrappers fall back to plain builtins/commands under `CURSOR_AGENT` / `CURSOR_TRACE`.

## Messages

All dotfiles stderr output uses one format (bash: `dotfiles_msg` in [`dotfiles-lib.sh`](zsh/.local/bin/dotfiles-lib.sh); zsh: `_dotfiles_msg` in `15-dotfiles-msg.zsh`):

```text
dotfiles: <label>: <details>
```

| Part | Style |
|------|--------|
| `dotfiles:` | bold + yellow |
| `<label>:` | yellow (not bold) |
| `<details>` | plain |

Labels in use: `repository out of sync`, `fix`, `optional tools not installed`, `rebuilt zsh completion cache`, `consider using`, `install`.

Examples:

```text
dotfiles: repository out of sync: uncommitted changes (3 file(s)); unstowed packages: zsh
dotfiles: fix: dotfiles-sync-fix (-n to preview)

dotfiles: optional tools not installed: bat, fd, eza, better-commits
dotfiles: fix: sudo apt install bat fd-find eza; better-commits: npm install -g better-commits

dotfiles: rebuilt zsh completion cache: scheduled; next refresh in 7 day(s)

dotfiles: consider using: rg
dotfiles: install: npm install -g better-commits
```

Startup checks skip output under `CURSOR_AGENT` / `CURSOR_TRACE`. Per-command hints (`grep`, `ls`, etc.) use the same format when wrappers fire.

## Dotfiles sync check

On interactive startup (once per day), `dotfiles-sync-check` warns when `~/.dotfiles` is out of sync:

- Uncommitted git changes
- Behind/ahead of upstream (`git fetch` once per check; disable with `DOTFILES_SYNC_CHECK_FETCH=0`)
- Stowed packages with new files not yet linked (`stow -n` on active packages only)

Example output (stderr):

```text
dotfiles: repository out of sync: uncommitted changes (3 file(s)); unstowed packages: zsh
dotfiles: fix: dotfiles-sync-fix (-n to preview)
```

`dotfiles-sync-fix` runs applicable steps in order (skips what does not apply):

1. `stow` for unstowed packages
2. `git add -A && git commit -m "chore(dotfiles): sync local changes"` (uses `command git` so the better-commits wrapper is bypassed)
3. `git pull` if behind upstream
4. `git push` if unpushed commits remain (re-checked after commit/pull; also runs when only ahead)

Override the commit message with `DOTFILES_SYNC_COMMIT_MSG`. Preview commands with `dotfiles-sync-fix -n`.

Shared helpers live in `dotfiles-lib.sh` (sourced by sync-check, sync-fix, and optional-deps-check).

Skipped under `CURSOR_AGENT` / `CURSOR_TRACE`.

```bash
DOTFILES_SYNC_CHECK_FORCE=1 dotfiles-sync-check    # re-check now
DOTFILES_SYNC_CHECK_FETCH=0 dotfiles-sync-check    # skip git fetch
dotfiles-sync-fix -n                               # preview fixes
DOTFILES_SYNC_COMMIT_MSG="chore: tweak zsh" dotfiles-sync-fix
DOTFILES_ROOT=~/other/dotfiles dotfiles-sync-check # non-default repo path
```

## Optional apt tools

On interactive startup (once per day), `dotfiles-optional-deps-check` warns if recommended tools are missing. It checks binaries on `PATH` (and `~/.fzf/bin/fzf`), suggests `sudo apt install …` for packages in your apt repos, and non-apt hints in the same `fix:` line. Skipped under `CURSOR_AGENT` / `CURSOR_TRACE` and on non-Debian systems.

Example output (stderr):

```text
dotfiles: optional tools not installed: bat, fd, eza, better-commits
dotfiles: fix: sudo apt install bat fd-find eza; better-commits: npm install -g better-commits
```

```bash
DOTFILES_OPTIONAL_DEPS_FORCE=1 dotfiles-optional-deps-check   # re-check now
```

Packages checked: `bat`, `fd-find`, `eza`, `git-delta`, `ripgrep`, `zoxide`, `fzf`, `jq`, `chafa`, `poppler-utils`, `mupdf-tools` (`mutool`), `ffmpegthumbnailer`, `atool`, `exiftool` (`libimage-exiftool-perl`), `mediainfo`, `duf`, `btop`, `gping` (snap on Pop!_OS), `mtr-tiny`, `gh`, `fnm`, `better-commits` (npm via fnm). See [fzf.md](fzf.md) and [README.md](../README.md) for what each enables.

## Gotchas

- `better-commits`, `zoxide`, `cat`, `df`, `htop`, `find`, `grep`, `ping`, and `ls` wrappers are disabled under `CURSOR_AGENT` / `CURSOR_TRACE`.
- Install [duf](https://github.com/muesli/duf) for the `df` wrapper; without it, plain `df` is unchanged.
- Install [btop](https://github.com/aristocratos/btop) for the `htop` wrapper; without it, plain `htop` is unchanged.
- Install [fd](https://github.com/sharkdp/fd) for faster fzf search and the `find` wrapper (`fdfind` on Debian/Ubuntu); without it, fzf falls back to `find .`.
- Install [gping](https://github.com/orf/gping) and/or `mtr` for the `ping` wrapper; without either, plain `ping` is unchanged.
- Install [eza](https://github.com/eza-community/eza) for the `ls` hint and `eza` wrapper; theme via `stow eza` — see [eza.md](eza.md). Pair with `stow smb` so mount ignores match your profiles.
- Install [zoxide](https://github.com/ajeetdsouza/zoxide) separately if you want the `cd` wrapper; it is not an antidote plugin.
- **fnm** — [fnm](https://github.com/Schniz/fnm) manages Node; `fnm env` is deferred so `node`/`npm` appear after the first prompt. `better-commits` needs Node ≥ 20.19: `fnm install --lts && npm install -g better-commits`.
- Tab completion uses a cached dump at `~/.cache/zsh/zcompdump`. A full `compinit` rebuild runs on a schedule (`ZSH_COMPINIT_REFRESH_DAYS`, default 7) and prints `dotfiles: rebuilt zsh completion cache: …` to stderr. Force immediately: `ZSH_COMPINIT_REFRESH_FORCE=1 exec zsh`. Manual reset: `rm -f ~/.cache/zsh/zcompdump ~/.cache/zsh/zcompdump.zwc ~/.cache/zsh/zcompdump.refresh.stamp`.
