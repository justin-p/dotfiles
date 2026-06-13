# SMB automount (multi-share)

Automount TrueNAS (or other) SMB shares via fstab + systemd automount. Each share is a **profile** with its own env + credentials files.

## Install (stow)

```bash
cd ~/.dotfiles
stow --ignore=README.md smb
```

## First-time setup

`setup-smb-mount` discovers every `~/.config/smb/*.env` profile and configures all mounts.

On first run it copies missing files from `*.example` and exits — edit them, then re-run:

```bash
setup-smb-mount   # may bootstrap *.env / *.credentials from examples
$EDITOR ~/.config/smb/homesrv.env
$EDITOR ~/.config/smb/homesrv.credentials
$EDITOR ~/.config/smb/nas.env
$EDITOR ~/.config/smb/nas.credentials
setup-smb-mount
ls ~/homesrv ~/nas
```

Find share names:

```bash
smbclient -L //YOUR_SERVER -U 'YOUR_USER'
```

## Profiles (committed examples)

| Profile | Env example | Credentials example | Typical mount |
|---------|-------------|---------------------|---------------|
| `homesrv` | `homesrv.env.example` | `homesrv.credentials.example` | `~/homesrv` |
| `nas` | `nas.env.example` | `nas.credentials.example` | `~/nas` |

Optional per-profile credentials override in `{name}.env`:

```bash
SMB_CREDENTIALS=${HOME}/.config/smb/nas.credentials
```

## Clean reset

```bash
cleanup-smb-mount
```

Unmounts all profiles, removes fstab entries, deletes local `*.env` and `*.credentials`. Stowed `*.example` files are kept.

## Local secrets (never committed)

| File | Purpose |
|------|---------|
| `~/.config/smb/{name}.env` | Server, share, mount point |
| `~/.config/smb/{name}.credentials` | Username + password (single source for auth) |

## Troubleshooting

**smbclient works, `mount error(13)` on mount:** userspace smbclient negotiates SMB3 encryption automatically; kernel `mount.cifs` does not unless you ask. Add to the profile `.env`:

```bash
SMB_MOUNT_OPTIONS=vers=3.1.1,seal
```

Then re-run `setup-smb-mount`. On TrueNAS, check whether the NAS share has SMB encryption enabled (Sharing → SMB → share → Advanced).

**Can read but not edit/save files (especially in Desktop/Documents):** Windows home folders often arrive with read-only directory permissions (`555`). Editors save via a temp file + rename, which needs directory write access. Mounts use `noperm` so Linux ignores those server ACLs; re-run `setup-smb-mount` after updating scripts.

Systemd unit names come from the mount path:

```bash
systemctl status "$(systemd-escape --path ~/homesrv).automount"
journalctl -u "$(systemd-escape --path ~/nas).mount" -n 20
mountpoint ~/homesrv ~/nas
```

## Add a share later

1. Add `{name}.env.example` and `{name}.credentials.example` to dotfiles
2. `stow -R --ignore=README.md smb`
3. Copy/edit local `{name}.env` and `{name}.credentials`
4. `setup-smb-mount`
