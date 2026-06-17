# Resolve .zshrc.d next to this file (works when ~/.zshrc is a stow symlink to ~/.dotfiles/zsh/.zshrc).
_zshrc_dir=${${(%):-%N}:A:h}/.zshrc.d
for _zshrc in ${_zshrc_dir}/*.zsh(N); do
  source "$_zshrc"
done
unset _zshrc _zshrc_dir
