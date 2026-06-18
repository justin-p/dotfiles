# PATH and toolchain setup for all zsh shells (sourced from ~/.zshenv).

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/snap/bin:$PATH"

[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go PATH="$PATH:$GOROOT/bin"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun" PATH="$BUN_INSTALL/bin:$PATH"

# Interactive-only: fnm Node/npm on PATH (synchronous; do not use system /usr/bin/node for npm globals).
if [[ -o interactive ]]; then
  [[ -d "$HOME/.local/share/fnm" ]] && export PATH="$HOME/.local/share/fnm:$PATH"
  command -v fnm &>/dev/null && eval "$(fnm env --shell zsh)"
fi
