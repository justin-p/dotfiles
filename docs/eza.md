# eza

[eza](https://github.com/eza-community/eza) theme and shell integration — modern `ls` replacement.

## Install (stow)

```bash
cd ~/.dotfiles
stow eza
```

Install the binary on the host (e.g. `sudo apt install eza` on Pop!_OS).

## Main file

| File | Purpose |
|------|---------|
| `~/.config/eza/theme.yml` | Bearded Theme feat. Gold D Raynh colors |

## Shell integration

| Shell | Behavior |
|-------|----------|
| **bash** | `ls` → `eza --icons=always --group-directories-first` ([bash.md](bash.md)) |
| **zsh** | `eza` function with defaults + SMB/tree ignores; `ls` is warn-only ([zsh.md](zsh.md)) |

Unset `LS_COLORS` / `EZA_COLORS` if they override the theme file.

### Zsh `eza` wrapper

Defined in `zsh/.zsh_alias.d/70-eza.zsh` when `eza` is on `PATH`.

**Default flags** (every `eza` invocation):

- `--icons=auto --group-directories-first -Alh --git --header`

**Auto-ignored paths** (via a single `-I` with pipe-separated globs):

| Pattern | When | Source |
|---------|------|--------|
| SMB mount basenames (`nas`, `homesrv`, …) | Always | `MOUNT_POINT` in each `~/.config/smb/*.env` ([smb.md](smb.md)) |
| `.git` | Tree mode only (`-T` / `--tree`) | Built-in |

If no SMB profiles exist, falls back to ignoring `nas`.

User-supplied `-I` / `--ignore-glob` overrides the matching pattern. To list a mount directly, pass its path: `eza ~/nas`.

**Examples**

```bash
eza              # long listing with git status; SMB mounts hidden in ~
eza -T           # tree; also skips .git and SMB mounts
eza -T --level 2 # shallower tree — full $HOME trees are still slow
eza ~/homesrv    # browse a mount explicitly
```

## Gotchas

- Theme path: `$XDG_CONFIG_HOME/eza/theme.yml` (or set `EZA_CONFIG_DIR`).
- Zsh `ls` wrapper is disabled under `CURSOR_AGENT` / `CURSOR_TRACE`; the `eza` function is not.
- eza only honors **one** `-I` flag — the wrapper joins patterns with `|` (multiple `-I` args would override each other).
- Full `eza -T` from `$HOME` can still be slow (large dotdirs, symlinks into `homesrv`, etc.) even with SMB mounts ignored — use `--level` or list paths directly.
- Add a new SMB profile under `~/.config/smb/` and open a new shell (or `source ~/.zsh_alias`) for the ignore list to pick it up.
