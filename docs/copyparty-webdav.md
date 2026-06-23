# copyparty WebDAV mount (rclone)

Mount a [copyparty](https://github.com/9001/copyparty) WebDAV share as a local folder via rclone FUSE.

## Install (stow)

```bash
cd ~/.dotfiles
stow copyparty-webdav
```

## First-time setup

On first run, `setup-copyparty-webdav` copies missing files from `*.example` and exits — edit them, then re-run:

```bash
setup-copyparty-webdav
$EDITOR ~/.config/copyparty-webdav/env
$EDITOR ~/.config/copyparty-webdav/credentials
setup-copyparty-webdav
copyparty-webdav-mount
ls ~/_copyparty-webdav
```

`setup-copyparty-webdav` also installs rclone to `~/.local/bin/rclone` when missing and creates/updates the rclone remote.

## Config

| File | Purpose |
|------|---------|
| `~/.config/copyparty-webdav/env` | WebDAV URL, mount point, rclone remote name |
| `~/.config/copyparty-webdav/credentials` | Username + password |

Committed examples: `env.example`, `credentials.example`.

## Commands

| Command | Purpose |
|---------|---------|
| `copyparty-webdav-mount` | Mount (daemon) |
| `copyparty-webdav-unmount` | Unmount |
| `setup-copyparty-webdav` | Bootstrap config + rclone remote |

## Auto-mount on login

```bash
systemctl --user daemon-reload
systemctl --user enable --now rclone-copyparty-webdav.service
```

## Troubleshooting

**Empty mount folder, no files:** FUSE mount failed — the directory is just a regular folder. Run `copyparty-webdav-mount` in a normal terminal (not Cursor's integrated terminal).

**Check mount:**

```bash
mountpoint ~/_copyparty
tail ~/.local/share/rclone-copyparty-webdav.log
journalctl --user -u rclone-copyparty-webdav.service -n 30
```

**Empty log file:** rclone never started (no mount attempt yet, or systemd exited before `exec rclone`). Use `journalctl` for the user service; the log file is only written once rclone runs.

**Log rotation:** by default logs rotate at 10M, keep 7 days, max 3 backups (`~/.local/share/rclone-copyparty-webdav.log*`). Override in `env`:

```bash
RCLONE_LOG_LEVEL=ERROR        # less verbose
RCLONE_LOG_MAX_SIZE=5M
RCLONE_LOG_MAX_AGE=3d
RCLONE_LOG_MAX_BACKUPS=2
```

Restart the mount after changing log settings.

**Test remote without mounting:**

```bash
rclone lsd copyparty-webdav:
```
