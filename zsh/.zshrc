# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /home/justin-p/git/github/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
    git
    heroku
    pip
    lein
    command-not-found
    tmux
    docker
    docker-compose
    emoji
    encode64
    vscode
    ssh-agent
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
EOBUNDLES

antigen theme romkatv/powerlevel10k
POWERLEVEL9K_MODE="awesome-patched"

antigen apply


# ColorLS
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
source $(dirname $(gem which colorls))/tab_complete.sh
alias ls='colorls --sd -A'

# Invoke-Item
alias ii=xdg-open

# stepstone connect
alias stepstone='ssh justin@stepstone -N'

alias pggm='ssh justin@pggm -N'

# firefox-dev
alias firefox-dev='~/tools/firefox/firefox'

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

