# PATH and toolchain setup for all zsh shells (sourced from ~/.zshenv).

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/snap/bin:$PATH"

[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go PATH="$PATH:$GOROOT/bin"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun" PATH="$BUN_INSTALL/bin:$PATH"

# Interactive-only: nvm must load synchronously so npm globals match the active node.
if [[ -o interactive ]]; then
  if [[ -d "$HOME/.local/share/fnm" ]]; then
    export PATH="$HOME/.local/share/fnm:$PATH"
  fi

  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  fi

  if [[ -n ${BUN_INSTALL:-} && -s "${BUN_INSTALL}/_bun" ]]; then
    source "${BUN_INSTALL}/_bun"
  fi
fi
