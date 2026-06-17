# history-substring-search: bind ↑/↓ after the antidote bundle loads the plugin (30-antidote.zsh).
if (( $+functions[history-substring-search-up] )); then
  zmodload zsh/terminfo 2>/dev/null
  if [[ -n ${terminfo[kcuu1]-} && -n ${terminfo[kcud1]-} ]]; then
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
  else
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
  fi
fi
