# Check if fzf is not installed in $HOME/.fzf; if not, clone and install it with bindings and completion
if [[ ! -d "$HOME/.fzf" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
fi
