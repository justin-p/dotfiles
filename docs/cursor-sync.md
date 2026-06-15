# Cursor settings sync

Editor settings live in the private repo [justin-p/cursor-settings](https://github.com/justin-p/cursor-settings), synced with the **Sync Settings** extension (`zokugun.sync-settings`).

## Local clone

```bash
git clone git@github.com:justin-p/cursor-settings.git ~/.cursor-settings
```

## Repository config (per machine)

File: `~/.config/Cursor/User/globalStorage/zokugun.sync-settings/settings.yml`

```yaml
profile: main
repository:
  type: git
  path: ~/.cursor-settings
  branch: main
```

A template is in `cursor-sync/settings.yml.example` (stow optional — only needed on new machines).

## Day to day

| Action | Command palette |
|--------|-----------------|
| Push local changes | `Sync Settings: Upload (user -> repository)` |
| Pull on a new/changed machine | `Sync Settings: Download (repository -> user)` |

Upload auto-pushes (`syncSettings.hooks.postUpload: git push`).

## New machine checklist

1. Clone `~/.cursor-settings` (above).
2. Copy or create `settings.yml` from `cursor-sync/settings.yml.example`.
3. Install Cursor extensions: **Cron Tasks**, **Sync Settings**.
4. **Download** once.

## What is synced

- Extensions list, settings, keybindings, snippets, tasks, MCP config
- Not synced: UI state (`state.vscdb` is huge), machine-specific paths (ignored in `syncSettings.ignoredSettings`)
