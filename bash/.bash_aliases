# LSDeluxe
alias ls='lsd'

# bat
alias cat='bat'

# ripgrep
alias grep='rg'

# Invoke-Item
alias ii='xdg-open'

# ssh shorthand commands
alias stepstone='ssh justin@stepstone -N'
alias shellserver='ssh justin@shellserver'

# ssh-add alias
alias ssh-add='ssh-add -t 1h'

# firefox-dev
alias firefox-dev='~/tools/firefox/firefox'

# find ansible galaxy api key
alias ansible-galaxy-api="/usr/bin/cat ~/.ansible/galaxy_token | cut -d ':' -f2 | tr -d ' '"
