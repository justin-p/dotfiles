[[ -e ${ZDOTDIR:-~}/.antidote ]] ||
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote
  
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
source <(antidote init)
antidote bundle < ~/.zsh_plugins

# aliasses
[ -f ~/.zsh_alias ] && source ~/.zsh_alias

# fzf search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# include hidden files in fzf
export FZF_DEFAULT_COMMAND='find .'

# fzf dedupe history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# fzf-tab
zstyle ':completion:*:descriptions' format '[%d]'

# Spaceship prompt
SPACESHIP_CHAR_SYMBOL="$"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_COLOR_SUCCESS="magenta"
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_COLOR="blue"

# extend path
export PATH=~/.local/bin:/snap/bin:$PATH
