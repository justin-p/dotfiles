# Setup fzf
# ---------
if [[ ! "$PATH" == */home/justin-p/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/justin-p/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/justin-p/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/justin-p/.fzf/shell/key-bindings.zsh"
