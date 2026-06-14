# SSH sync (homesrv)

`~/.ssh` stays on local disk — OpenSSH rejects private keys on network mounts (CIFS) and requires mode `700`/`600`. This script keeps a merged copy on `~/homesrv/.ssh` for backup and use on other machines.

## Install (stow)

```bash
cd ~/.dotfiles
stow ssh-sync
install-sync-ssh-timer
```

## Manual sync

```bash
sync-ssh
```

## Schedule

A **systemd user timer** runs `sync-ssh --quiet` every 15 minutes (and once ~2 minutes after login). This avoids slowing down every new zsh session while CIFS is mounted.

```bash
systemctl --user status sync-ssh.timer
journalctl --user -u sync-ssh.service -n 20
```

Disable: `systemctl --user disable --now sync-ssh.timer`

## Behaviour

- Skips when `~/homesrv` is not mounted
- Bidirectional merge with `rsync --update` (newer file wins; nothing deleted)
- Excludes ephemeral agent/control sockets
- Restores local permissions after each sync

## Why not symlink?

Symlinking `~/.ssh` to `~/homesrv/.ssh` breaks `ssh`/`git` because CIFS cannot enforce Unix key permissions reliably.
