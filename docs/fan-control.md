# Fan Control

[Fan Control](https://github.com/Rem0o/FanControl) configuration: fan curves and sensor/control bindings for GPU and motherboard fans.

**Not a stow package.** Hardware identifiers are machine-specific.

## Layout

```
fan_control/
  userConfig.json
```

## Install

Copy `userConfig.json` into Fan Control’s config directory on the target machine, then adjust sensor and control bindings for that hardware.

## Gotchas

- Bindings reference specific devices (`NVApiWrapper/...`, `/lpc/nct6792d/...`) — not portable without editing.
- Some controls may be disabled in the saved config.
