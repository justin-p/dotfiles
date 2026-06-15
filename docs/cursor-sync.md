# Cursor settings sync

Editor settings live in the private repo [justin-p/cursor-settings](https://github.com/justin-p/cursor-settings), synced with the **Sync Settings** extension (`zokugun.sync-settings`).

## Install (stow)

```bash
cd ~/.dotfiles
stow cursor-sync
```

## Local clone

```bash
git clone git@github.com:justin-p/cursor-settings.git ~/.cursor-settings
```

## First-time setup

Copy the stowed template to the path Sync Settings reads (the extension does not sync this file):

```bash
cp ~/.config/Cursor/User/globalStorage/zokugun.sync-settings/settings.yml.example \
   ~/.config/Cursor/User/globalStorage/zokugun.sync-settings/settings.yml
```

Template in the repo: `cursor-sync/.config/Cursor/User/globalStorage/zokugun.sync-settings/settings.yml.example`

## Day to day

| Action | Command palette |
|--------|-----------------|
| Push local changes | `Sync Settings: Upload (user -> repository)` |
| Pull on a new/changed machine | `Sync Settings: Download (repository -> user)` |

Upload auto-pushes (`syncSettings.hooks.postUpload: git push`).

## New machine checklist

1. `stow cursor-sync`
2. Clone `~/.cursor-settings` (above).
3. Copy `settings.yml.example` → `settings.yml` (above).
4. Install Cursor extensions: **Cron Tasks**, **Sync Settings**.
5. **Download** once.

## What is synced

- Extensions list, settings, keybindings, snippets, tasks, MCP config
- Not synced: UI state (`state.vscdb` is huge), machine-specific paths (ignored in `syncSettings.ignoredSettings`)
