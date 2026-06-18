# Defer slow eval/source calls until after the first prompt (romkatv/zsh-defer).
if (( $+functions[zsh-defer] )); then
  [[ -f "$HOME/.cargo/env" ]] && zsh-defer source "$HOME/.cargo/env"

  [[ -n ${BUN_INSTALL:-} && -s "${BUN_INSTALL}/_bun" ]] && \
    zsh-defer source "${BUN_INSTALL}/_bun"
fi
