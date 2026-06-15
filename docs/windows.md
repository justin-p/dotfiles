# Windows bootstrap

Windows-only setup scripts at the repo root. Not used on Linux.

## bootstrap.ps1

**Run as Administrator** from the dotfiles repo:

```powershell
.\bootstrap.ps1
```

Creates symlinks (custom `StowFile`) for:

| Source | Target |
|--------|--------|
| `Powershell/profile.ps1` | PowerShell profile |
| `Powershell/Microsoft.PowerShellISE_profile.ps1` | ISE profile |
| `git/.gitconfig` | `~/.gitconfig` |
| `vim/.vimrc` | `~/_vimrc` |

Also configures `core.excludesfile` to `~/.gitignore_global`.

See [powershell.md](powershell.md) and [git.md](git.md).

## update.ps1

**Run as Administrator:**

```powershell
.\update.ps1
```

- `git pull --ff-only` on `~/.gitlist` repos and this dotfiles repo
- `cup all -y --except mobaxterm` (Chocolatey upgrade all; mobaxterm excluded to preserve license)

## Gotchas

- Requires admin for symlinks.
- Falls back to file copy if the profile path is on a network share.
- References `windows-terminal/profiles.json` and `git/.gitignore` which may not exist in this repo.
