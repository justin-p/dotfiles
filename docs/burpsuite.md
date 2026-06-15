# Burp Suite Pro

Burp Suite Pro user config: Darcula UI, BApp extensions, proxy and display defaults.

## Install (stow)

```bash
cd ~/.dotfiles
stow BurpSuite
```

## Main file

`~/.BurpSuite/UserConfigPro.json`

## Gotchas

- Paths are machine-specific (Jython jar, custom extension at `~/Documents/burp-ssp-decoder.jar`).
- Most of `~/.BurpSuite/` is gitignored; only config (and jython jar whitelist) is tracked.
