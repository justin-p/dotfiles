# SMB homeshare automount

Automount a TrueNAS (or other) SMB share at `~/homesrv` via fstab + systemd automount.

## Install (stow)

```bash
cd ~/.dotfiles
stow --ignore=README.md smb
```

## First-time setup

```bash
cp ~/.config/smb/homesrv.env.example ~/.config/smb/homesrv.env
cp ~/.config/smb/credentials.example ~/.config/smb/credentials
$EDITOR ~/.config/smb/homesrv.env    # SMB_SERVER, SMB_SHARE, SMB_USER
$EDITOR ~/.config/smb/credentials    # username and password
setup-homesrv-mount
ls ~/homesrv
```

## Clean reset (remove old install)

```bash
cleanup-homesrv-mount
```

Removes fstab entry, unmounts, and deletes local `homesrv.env` / `credentials`. Stow symlinks and `*.example` files are kept.

Find your share name:

```bash
smbclient -L //YOUR_SERVER -U 'YOUR_USER'
```

## Local secrets (never committed)

| File | Purpose |
|------|---------|
| `~/.config/smb/homesrv.env` | Server, share, user, mount point (no password) |
| `~/.config/smb/credentials` | SMB username + password for `mount.cifs` |

## Troubleshooting

Systemd unit names are derived from your mount path (use `systemd-escape`, not hand-typed `\x2d`):

```bash
systemctl status "$(systemd-escape --path ~/homesrv).automount"
journalctl -u "$(systemd-escape --path ~/homesrv).mount" -n 20
mountpoint ~/homesrv
```

If `MOUNT_POINT` in `homesrv.env` is not `~/homesrv`, substitute that path in `systemd-escape --path`.
