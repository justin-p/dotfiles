# Spaceship prompt

Spaceship Zsh prompt customization: time, user@host, git branch/status/commit, command duration.

## Install (stow)

```bash
cd ~/.dotfiles
stow spaceship
stow zsh    # loads the plugin via antidote
```

## Main file

`~/.spaceshiprc.zsh`

## Gotchas

The Spaceship plugin itself is loaded from `zsh/.zsh_plugins` (antidote). This package only provides the config file.
