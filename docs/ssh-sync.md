# SSH sync (homesrv)

`~/.ssh` stays on local disk — OpenSSH rejects private keys on network mounts (CIFS) and requires mode `700`/`600`. This script keeps a per-machine **key** backup under `~/homesrv/.ssh/machines/<name>/` and syncs it with local `~/.ssh`. `config` and `known_hosts` stay local to each machine.

## Layout

```
~/homesrv/.ssh/
  machines/
    main-pc/
    work-laptop/
    ...
```

Each machine **reads and writes keys** only in its own folder (`machines/<name>/`). Other machines' folders on homesrv are not touched.

Override the folder name when two machines share a short hostname, or when the system hostname is not the name you want:

```bash
export SSH_SYNC_MACHINE_ID=work-laptop
```

Or create a local file (not committed):

```bash
mkdir -p ~/.config/ssh-sync
echo work-laptop > ~/.config/ssh-sync/machine-id
```

Copy from `ssh-sync/.config/ssh-sync/machine-id.example` on a new machine if needed.

## Install (stow)

```bash
cd ~/.dotfiles
stow ssh-sync
install-sync-ssh-keys-to-homesrv-timer
```

## Manual sync

```bash
sync-ssh-keys-to-homesrv
```

## Schedule

A **systemd user timer** runs `sync-ssh-keys-to-homesrv --quiet` every 15 minutes (and once ~2 minutes after login). This avoids slowing down every new zsh session while CIFS is mounted.

```bash
systemctl --user status sync-ssh-keys-to-homesrv.timer
journalctl --user -u sync-ssh-keys-to-homesrv.service -n 20
```

Disable: `systemctl --user disable --now sync-ssh-keys-to-homesrv.timer`

## Behaviour

- Skips when `~/homesrv` is not mounted
- Bidirectional key sync (`id_*`, `*_key`, `*.pub`) between `~/.ssh` and `~/homesrv/.ssh/machines/<this-machine>/` only
- `config`, `known_hosts`, and other non-key files are not synced
- Machines can sync concurrently — each uses a separate folder
- Timer uses `RandomizedDelaySec=5min` to spread load on the NAS
- Merge with `rsync --update` (newer file wins; nothing deleted)
- Excludes ephemeral agent/control sockets
- Restores local permissions after each sync (`id_*` and `*_key` private keys → `600`, `*.pub` → `644`)
- On first run, moves a legacy flat `~/homesrv/.ssh/*` layout into `machines/<this-host>/`

## Why not symlink?

Symlinking `~/.ssh` to `~/homesrv/.ssh` breaks `ssh`/`git` because CIFS cannot enforce Unix key permissions reliably.

## Gotchas

- CIFS/rsync can leave private keys at `0644`. The sync script resets `id_*` and `*_key` (non-`.pub`) to `600` after each run. If git signing fails with `UNPROTECTED PRIVATE KEY FILE`, fix immediately: `chmod 600 ~/.ssh/justin_p_github_signing_key` then `ssh-add` it again — see [git.md](git.md#commit-signing-fails-agent-refused-operation).
