# Setup fzf
# ---------
if [[ ! "$PATH" == */home/justin-p/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/justin-p/.fzf/bin"
fi

eval "$(fzf --bash)"
