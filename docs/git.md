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

- Signing uses **SSH keys** (`gpg.format = ssh`), not GPG — see `user.signingkey` and `~/.config/git/allowed_signers`.
- Signing key: `~/.ssh/justin_p_github_signing_key` (private) / `.pub` (in gitconfig); sync via [ssh-sync.md](ssh-sync.md).
- `includeIf` loads `~/.gitconfig-work` for `~/git/gitlab-work/` (not in this repo).
- `better-commits` wrapper in `zsh/.zsh_alias.d/30-git.zsh`: bare `git commit` or bare `git add` (no arguments) invokes `better-commits` when installed; otherwise prints a prefer-tool hint with `npm install -g better-commits` and falls through to git. Requires Node ≥ 20.19 via [fnm](https://github.com/Schniz/fnm) (`fnm install --lts`), loaded from `~/.zpath.zsh`. `git add <file>`, `git commit -m`, etc. always pass through to git. `dotfiles-sync-fix` uses `command git commit -m …` so it does not invoke better-commits.
- OMZ `git` plugin aliases (e.g. `gd` for `git diff`) work with the delta pager once `stow git` is applied.
- Git diffs use [delta](https://github.com/dandavison/delta), not bat — see [bat.md](bat.md) for what bat covers instead.
- `git-pager-delta` isolates delta's bat cache from host `batcat` (`~/.cache/delta-bat/`) so theme loading does not break.

### Commit signing fails (`agent refused operation`)

Git calls `ssh-keygen -Y sign` via `ssh-agent`. If the agent has no key, the key timed out, or the shell cannot talk to your login agent (common in **Cursor agent** terminals), you get:

```text
Couldn't sign message (signer): agent refused operation?
fatal: failed to write commit object
```

**Fix (normal terminal):** load the signing key, then commit again:

```bash
chmod 600 ~/.ssh/justin_p_github_signing_key   # if ssh-add warns about permissions (see ssh-sync.md)
ssh-add ~/.ssh/justin_p_github_signing_key
ssh-add -l   # should list “(Git signing)” without UNPROTECTED PRIVATE KEY warnings
git commit -m "your message"
```

**Fix (Cursor agent / headless):** commit from COSMIC Terminal or another interactive shell where `ssh-add` works, or one-off unsigned (only if your remote allows it):

```bash
git -c commit.gpgsign=false commit -m "your message"
```
