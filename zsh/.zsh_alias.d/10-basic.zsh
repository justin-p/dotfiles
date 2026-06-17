# Invoke-Item
alias ii='xdg-open'

# enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  if ! command -v eza &>/dev/null; then
    alias ls='ls --color=auto'
  fi
  alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  if ! command -v rg &>/dev/null; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
fi
