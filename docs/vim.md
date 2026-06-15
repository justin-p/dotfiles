# Vim

Vim config based on [amix/vimrc](https://github.com/amix/vimrc) with Nord colorscheme.

## Install (stow)

```bash
cd ~/.dotfiles
stow vim
```

On Windows, `bootstrap.ps1` symlinks to `~/_vimrc` — see [windows.md](windows.md).

## Main files

- `~/.vimrc`
- `~/.vim/colors/nord.vim`

## Gotchas

Minimal plugin set in this package; `g:airline_theme` is set but airline is not bundled here.
