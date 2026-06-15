
# bat / batcat (Debian/Ubuntu: batcat)
if command -v bat &>/dev/null; then
  _bat_cmd=bat
elif command -v batcat &>/dev/null; then
  _bat_cmd=batcat
fi
if [[ -n ${_bat_cmd:-} ]]; then
  alias cat="${_bat_cmd} --paging=never"
  alias bat="${_bat_cmd}"
  bathelp() {
    local tmp
    tmp=$(mktemp "${TMPDIR:-/tmp}/bathelp.XXXXXX") || return 1
    cat > "$tmp"
    bat --color=always --style=plain --language=help --paging=never "$tmp"
    rm -f "$tmp"
  }
  chelp() { command "$@" --help 2>&1 | bathelp; }
  _fzf_file_preview="${HOME}/.local/bin/fzf-file-preview"
  [[ -x $_fzf_file_preview ]] || _fzf_file_preview="${HOME}/.dotfiles/fzf/.local/bin/fzf-file-preview"
  # https://github.com/sharkdp/bat#integration-with-other-tools
  export MANPAGER="${_bat_cmd} -plman"
  if [[ -x $_fzf_file_preview ]]; then
    export FZF_CTRL_T_OPTS="--preview-window=right:55%,border-rounded --preview=${_fzf_file_preview}\ {}"
  fi
  unset _bat_cmd _fzf_file_preview
fi

alias ii='xdg-open'

# find ansible galaxy api key
alias ansible-galaxy-api="/usr/bin/cat ~/.ansible/galaxy_token | cut -d ':' -f2 | tr -d ' '"
