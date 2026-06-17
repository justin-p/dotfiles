# Defer slow eval/source calls until after the first prompt (romkatv/zsh-defer).
if (( $+functions[zsh-defer] )); then
  command -v fnm &>/dev/null && zsh-defer eval "$(fnm env)"

  [[ -f "$HOME/.cargo/env" ]] && zsh-defer source "$HOME/.cargo/env"

  [[ -n ${BUN_INSTALL:-} && -s "${BUN_INSTALL}/_bun" ]] && \
    zsh-defer source "${BUN_INSTALL}/_bun"
fi
