# Boot splash — Bearded-Gold-D-Raynh

Match Plymouth boot splash and COSMIC greeter login screen to the Bearded-Gold desktop theme: navy `#0e1424`, gold `#e39000`, no Pop logo.

**Not a stow package.** Run the install scripts with `sudo`; they deploy to system paths (`/usr/share/plymouth`, `/var/lib/cosmic-greeter`, etc.).

## Layout

```
boot-theme/
  install.sh              # Plymouth + greeter
  plymouth/
    install.sh
    generate-assets.sh
    generate-assets.py
    assets/
    bearded-gold/
  greeter/
    install.sh
```

## Boot stages

| Stage | What controls it | This setup |
|-------|------------------|------------|
| UEFI / firmware logo | BIOS/firmware (before OS) | Not themed |
| Plymouth boot splash | `bearded-gold` Plymouth theme in initramfs | Navy background, gold progress, no logo |
| COSMIC greeter | `/var/lib/cosmic-greeter/.config/cosmic/` | Bearded theme + system wallpaper |

## Install

Run once (requires sudo), then reboot:

```bash
sudo ~/.dotfiles/boot-theme/install.sh
```

Or install each stage separately:

```bash
sudo ~/.dotfiles/boot-theme/plymouth/install.sh
sudo ~/.dotfiles/boot-theme/greeter/install.sh
```

### Plymouth

Regenerates PNG assets if missing, copies theme to `/usr/share/plymouth/themes/bearded-gold/`, sets it as default, rebuilds initramfs, and runs `kernelstub`.

`lock.png` uses [Jam Icons padlock-f](https://proicons.com/icons/155597/padlock-f/) (MIT) recolored to `#e39000`. Regenerating assets requires Node.js (`npx sharp-cli`).

### Greeter

Installs wallpaper to `/usr/share/backgrounds/bearded-gold-d-raynh-bg.png`, deploys Bearded theme config for the `cosmic-greeter` user, updates your user background path to the system location, and restarts greeter services. Wallpaper source: `cosmic-theme/bearded-gold-d-raynh-bg.png`.

## Preview Plymouth without reboot

```bash
sudo plymouthd
sudo plymouth --show-splash
sudo plymouth change-mode --boot-up    # also try --updates, --shutdown
sleep 5
sudo plymouth quit
```

## Regenerate assets

After editing colors in `plymouth/bearded-gold/bearded-gold.plymouth`:

```bash
~/.dotfiles/boot-theme/plymouth/generate-assets.sh
sudo ~/.dotfiles/boot-theme/plymouth/install.sh
```

## Revert to Pop default

```bash
sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/pop-basic/pop-basic.plymouth
sudo update-initramfs -u -k all
sudo kernelstub
```

Greeter: remove `/var/lib/cosmic-greeter/.config/cosmic/` and restart `cosmic-greeter` services.

## Troubleshooting

**Plymouth still shows Pop logo** — confirm active theme:

```bash
readlink -f /etc/alternatives/default.plymouth
```

Should point to `.../bearded-gold/bearded-gold.plymouth`. Re-run install script.

**Greeter still shows nebula** — greeter may flash the bundled fallback before loading config. Verify:

```bash
sudo ls /var/lib/cosmic-greeter/.config/cosmic/com.system76.CosmicBackground/v1/all
sudo ls /usr/share/backgrounds/bearded-gold-d-raynh-bg.png
```

Restart services: `sudo systemctl restart cosmic-greeter-daemon cosmic-greeter`

**Solid wallpaper not on login screen** — known COSMIC quirk; this setup uses the PNG at a system-readable path instead of a color-only background.

**Theme colors wrong on greeter until user selected** — click your user account; per-user theme loads from your `~/.config/cosmic/`. Greeter system config sets the default before selection.

**apt upgrade overwrote theme** — `bearded-gold` lives in a separate directory; `pop-plymouth-theme` updates do not touch it. Re-run install if initramfs was rebuilt without your theme.

See also: [cosmic-theme.md](cosmic-theme.md)
