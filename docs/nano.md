# nano

nano editor config with vendored syntax highlighting ([galenguyer/nano-syntax-highlighting](https://github.com/galenguyer/nano-syntax-highlighting)).

## Install (stow)

```bash
cd ~/.dotfiles
stow nano
```

## Main files

- `~/.nanorc`
- `~/.nano/*.nanorc` (language syntax files)

## Refresh upstream syntax files

Optional — re-fetches from upstream:

```bash
~/.nano/install.sh
```

Upstream readme: `nano/.nano/readme.md`
