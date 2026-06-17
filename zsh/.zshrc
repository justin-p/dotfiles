# Resolve .zshrc.d next to this file (works when ~/.zshrc is a stow symlink to ~/.dotfiles/zsh/.zshrc).
_zshrc_dir=${${(%):-%N}:A:h}/.zshrc.d
for _zshrc in ${_zshrc_dir}/*.zsh(N); do
  source "$_zshrc"
done
unset _zshrc _zshrc_dir

# fnm
FNM_PATH="/home/justin-p/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi
