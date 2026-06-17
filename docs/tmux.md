# tmux

tmux with TPM, tmux-sensible, and nord-tmux theme. Large scrollback buffer.

## Install (stow)

```bash
cd ~/.dotfiles
stow tmux
dotfiles-tmux-bootstrap    # clone TPM once if missing
```

## Main files

| File | Purpose |
|------|---------|
| `~/.tmux.conf` | tmux config and plugin list |
| `~/.local/bin/dotfiles-tmux-bootstrap` | Clone `~/.tmux/plugins/tpm` when missing |

## First-time plugin install

After `dotfiles-tmux-bootstrap`, open tmux and run:

```
prefix + I    # install plugins
```

## Plugins

- [tpm](https://github.com/tmux-plugins/tpm)
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- [nord-tmux](https://github.com/arcticicestudio/nord-tmux)
