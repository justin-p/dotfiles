# Resolve .zpath.zsh next to this file (works when ~/.zshenv is a stow symlink).
_zpath=${${(%):-%N}:A:h}/.zpath.zsh
[[ -f $_zpath ]] && source "$_zpath"
unset _zpath
