# Source the fzf zsh integration script if it exists, enabling key bindings & tab completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Ctrl+Left / Ctrl+Right: many terminals send CSI 1;5D / 1;5C. Without bindkey, zsh can echo ";5C" etc.
() {
  local km
  for km in emacs viins vicmd; do
    bindkey -M "$km" $'\e[1;5D' backward-word
    bindkey -M "$km" $'\e[1;5C' forward-word
  done
}

# fzf: fd/fdfind when installed (hidden files, follows symlinks); else find
if [[ -n ${_FD_CMD:-} ]]; then
  export FZF_DEFAULT_COMMAND="$_FD_CMD --hidden --follow --exclude .git"
else
  export FZF_DEFAULT_COMMAND='find .'
fi

# zoxide + fzf: https://zoxide.org/tutorials/fzf-integration/
# _ZO_FZF_OPTS replaces (not merges) FZF_DEFAULT_OPTS for zi — include theme + zoxide flags + preview.
if command -v zoxide &>/dev/null; then
  if command -v fzf &>/dev/null || [[ -x ${HOME}/.fzf/bin/fzf ]]; then
    typeset -ga _zo_fzf_opts=( ${=FZF_DEFAULT_OPTS} )
    _zo_fzf_opts+=(
      --exact
      --no-sort
      --bind=ctrl-z:ignore,btab:up,tab:down
      --cycle
      --keep-right
      --tabstop=1
      --exit-0
      --preview-window=right:55%,border-rounded
    )
    if [[ -x $_FZF_FILE_PREVIEW ]]; then
      _zo_fzf_opts+=("--preview='${_FZF_FILE_PREVIEW} {2}'")
    elif command -v eza &>/dev/null; then
      _zo_fzf_opts+=("--preview='eza -Al --color=always --icons=auto --group-directories-first {2}'")
    else
      _zo_fzf_opts+=("--preview='ls -Cp --color=always --group-directories-first {2}'")
    fi
    export _ZO_FZF_OPTS="${(j: :)_zo_fzf_opts[@]}"
    unset _zo_fzf_opts
  fi
fi
