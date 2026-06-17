# Check if the Antidote plugin manager is installed in ~/.antidote (or $ZDOTDIR/.antidote), clone if missing
[[ -e ${ZDOTDIR:-~}/.antidote ]] || \
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Source Antidote's main script to enable plugin bundling features
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# appup (mdeboer/zsh-plugin-appup): zstyle must be set before the plugin loads
_zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
zstyle ':omz:plugins:appup:docker' check-started yes

if [[ ! ${_zsh_plugins}.zsh -nt $_zsh_plugins ]]; then
  antidote bundle <"$_zsh_plugins" >|"${_zsh_plugins}.zsh"
fi
source "${_zsh_plugins}.zsh"
unset _zsh_plugins
