# Git

Global Git config: SSH commit signing, `gh` credential helper, LFS, push defaults, and global gitignore.

## Install (stow)

```bash
cd ~/.dotfiles
stow git
```

On Windows, `bootstrap.ps1` symlinks `.gitconfig` instead — see [windows.md](windows.md).

## Main files

| File | Purpose |
|------|---------|
| `~/.gitconfig` | User identity, signing, push, credential helper |
| `~/.gitignore_global` | Global ignore patterns |
| `~/.better-commits.jsonc` | [better-commits](https://github.com/pvande/better-commits) prompt config |

## Gotchas

- Signing key: `~/.ssh/justin_p_github_signing_key.pub` (sync via [ssh-sync.md](ssh-sync.md)).
- `includeIf` loads `~/.gitconfig-work` for `~/git/gitlab-work/` (not in this repo).
- `better-commits` wrapper alias lives in `zsh/.zsh_alias`.
