# PATH and toolchain setup for all zsh shells (sourced from ~/.zshenv).

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/snap/bin:$PATH"

[[ -d /usr/local/go ]] && export GOROOT=/usr/local/go PATH="$PATH:$GOROOT/bin"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.bun/bin" ]] && export BUN_INSTALL="$HOME/.bun" PATH="$BUN_INSTALL/bin:$PATH"

# Interactive-only: fnm binary on PATH; `fnm env` deferred in 110-deferred.zsh.
if [[ -o interactive ]]; then
  [[ -d "$HOME/.local/share/fnm" ]] && export PATH="$HOME/.local/share/fnm:$PATH"
fi
