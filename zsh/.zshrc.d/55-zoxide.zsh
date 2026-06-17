# zoxide: init before aliases so cd/z/zi work immediately after startup.
if ! command -v zoxide &>/dev/null && [[ -x ${HOME}/.cargo/bin/zoxide ]]; then
  export PATH="${HOME}/.cargo/bin:${PATH}"
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi
