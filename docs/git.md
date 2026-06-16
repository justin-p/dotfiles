# Git

Global Git config: SSH commit signing, `gh` credential helper, LFS, push defaults, global gitignore, and [delta](https://github.com/dandavison/delta) diffs with a Bearded Theme palette.

## Install (stow)

```bash
cd ~/.dotfiles
stow git
```

`stow git` symlinks `~/.gitconfig`, `~/.delta-themes.gitconfig`, `~/.gitignore_global`, `~/.better-commits.jsonc`, and `~/.local/bin/git-pager-delta`.
Install delta on the host (e.g. `sudo apt install git-delta`). Without delta, the pager falls back to `less -FRX`.

On Windows, `bootstrap.ps1` symlinks `.gitconfig` instead — see [windows.md](windows.md).

## Main files

| File | Purpose |
|------|---------|
| `~/.gitconfig` | User identity, signing, push, credential helper, delta options |
| `~/.delta-themes.gitconfig` | Delta color theme (`bearded-theme-feat-gold-d-raynh`) |
| `~/.local/bin/git-pager-delta` | Pager wrapper: `delta` when installed, else `less -FRX` |
| `~/.gitignore_global` | Global ignore patterns |
| `~/.better-commits.jsonc` | [better-commits](https://github.com/pvande/better-commits) prompt config |

## Delta

Colors match **Bearded Theme feat. Gold D Raynh** (same palette as [cosmic-term](cosmic-term.md) / [zsh](zsh.md) fzf). The theme is a [delta custom feature](https://dandavison.github.io/delta/custom-themes.html) activated via:

```gitconfig
[delta]
    features = bearded-theme-feat-gold-d-raynh
```

Edit colors in `git/.delta-themes.gitconfig`. Layout options (`side-by-side`, `navigate`, `hyperlinks`, etc.) live in `git/.gitconfig`.

Pager config uses a direct path (no `!` shell prefix — git config mangles quoted `!sh -c` values):

```gitconfig
[pager]
    diff = ~/.local/bin/git-pager-delta
    show = ~/.local/bin/git-pager-delta
```

## Gotchas

- Signing key: `~/.ssh/justin_p_github_signing_key.pub` (sync via [ssh-sync.md](ssh-sync.md)).
- `includeIf` loads `~/.gitconfig-work` for `~/git/gitlab-work/` (not in this repo).
- `better-commits` wrapper alias lives in `zsh/.zsh_alias`.
- OMZ `git` plugin aliases (e.g. `gd` for `git diff`) work with the delta pager once `stow git` is applied.
- Git diffs use [delta](https://github.com/dandavison/delta), not bat — see [bat.md](bat.md) for what bat covers instead.
- `git-pager-delta` isolates delta's bat cache from host `batcat` (`~/.cache/delta-bat/`) so theme loading does not break.
