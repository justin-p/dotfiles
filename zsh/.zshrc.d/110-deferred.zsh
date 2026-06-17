# Defer slow eval/source calls until after the first prompt (romkatv/zsh-defer).
if (( $+functions[zsh-defer] )); then
  if [[ -d "$HOME/.local/share/fnm" ]] && command -v fnm &>/dev/null; then
    zsh-defer eval "$(fnm env)"
  fi

  [[ -f "$HOME/.cargo/env" ]] && zsh-defer source "$HOME/.cargo/env"
fi
