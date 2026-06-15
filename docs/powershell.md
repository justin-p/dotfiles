# PowerShell (Windows)

PowerShell profile for Windows: Chocolatey tab-completion, posh-git, oh-my-posh, colored directory listings.

**Windows only** — deployed by [windows.md](windows.md) `bootstrap.ps1`, not stowed.

## Main files

| File | Purpose |
|------|---------|
| `Powershell/profile.ps1` | Main profile (Windows Terminal / VS Code) |
| `Powershell/Microsoft.PowerShellISE_profile.ps1` | ISE profile (Chocolatey completion only) |

## Prerequisites

Install modules separately, e.g.:

```powershell
Install-Module posh-git, Terminal-Icons -Scope CurrentUser
```

oh-my-posh theme loads only when the parent process is Windows Terminal or VS Code.
