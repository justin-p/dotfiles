# Firefox theme — Bearded Theme feat. Gold D Raynh

Firefox theme matching Bearded Theme feat. Gold D Raynh.

Uses a local theme extension plus `userChrome.css` / `userContent.css` for full coverage (Proton UI and `about:newtab`).

## Install (stow)

```bash
cd ~/.dotfiles
stow firefox
install-bearded-firefox-theme
```

Launch Firefox once first if no profile exists yet (`~/.config/mozilla/firefox/` on Firefox 147+).

Restart Firefox after install.

## What it configures

| Target | Purpose |
|--------|---------|
| `~/.local/share/firefox-theme/bearded-gold-d-raynh/` | Theme extension source (`manifest.json`, CSS) |
| `profile/extensions/bearded-gold-d-raynh@dotfiles.local` | Symlink to theme extension |
| `profile/chrome/userChrome.css` | Tab bar, nav bar, bookmarks, sidebar, URL bar |
| `profile/chrome/userContent.css` | New Tab / Home page colors and tiles |
| `profile/user.js` | Activates theme + enables custom stylesheets |

Profile search order:

1. `~/.config/mozilla/firefox` (XDG, Firefox 147+)
2. `~/.mozilla/firefox` (legacy)
3. Flatpak / Snap paths

## Re-apply after changes

```bash
install-bearded-firefox-theme
```

Edits to files in `~/.dotfiles/firefox/.local/share/firefox-theme/bearded-gold-d-raynh/` take effect after re-running the installer and restarting Firefox.

## Key colors

| Role | Hex |
|------|-----|
| Tab bar / sidebar | `#0c1220` |
| Toolbar / NTP background | `#0e1424` |
| Active tab / editor | `#0f1628` |
| URL bar / inputs | `#121b31` |
| Cards / popups | `#16203b` |
| Text | `#b8c4e4` |
| Inactive tab text | `#334984` |
| Accent / tab underline | `#e39000` |

## Troubleshooting

**Still default Firefox look** — theme not active. Check `about:support` → Profile Folder, then:

```bash
grep activeThemeID "$(dirname "$(grep Path ~/.config/mozilla/firefox/profiles.ini -A2 | grep Path | head -1 | cut -d= -f2)")/user.js"
```

Should show `bearded-gold-d-raynh@dotfiles.local`. Re-run `install-bearded-firefox-theme`.

**Custom CSS not loading** — confirm in `about:config`:

- `toolkit.legacyUserProfileCustomizations.stylesheets` = `true`

**New Tab still wrong** — `userContent.css` only applies to `about:newtab` / `about:home`. Third-party new-tab extensions override it.

**Temporary test** — `about:debugging` → This Firefox → Load Temporary Add-on → pick `manifest.json` from the theme folder.

## Files

```
firefox/
  .local/bin/install-bearded-firefox-theme
  .local/share/firefox-theme/bearded-gold-d-raynh/
    manifest.json
    userChrome.css
    userContent.css
```
