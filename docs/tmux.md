# tmux

tmux with TPM, tmux-sensible, and nord-tmux theme. Large scrollback buffer.

## Install (stow)

```bash
cd ~/.dotfiles
stow tmux
```

## Main file

`~/.tmux.conf`

## First-time plugin install

`zsh/.zshrc` auto-clones `~/.tmux/plugins/tpm` on first shell login if missing. Then in tmux:

```
prefix + I    # install plugins
```

## Plugins

- [tpm](https://github.com/tmux-plugins/tpm)
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- [nord-tmux](https://github.com/arcticicestudio/nord-tmux)
