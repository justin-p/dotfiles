# bat: syntax-highlighted cat (https://github.com/sharkdp/bat; disabled under Cursor agent shells)
cat() {
  if _cursor_agent_shell; then
    command cat "$@"
    return
  fi

  if [[ -n ${_BAT_CMD:-} ]]; then
    "$_BAT_CMD" --paging=never "$@"
  else
    command cat "$@"
  fi
}

# bat: colorized command help (https://github.com/sharkdp/bat#highlighting---help-messages)
if [[ -n ${_BAT_CMD:-} && -n ${_BAT_HELP_OK:-} ]]; then
  bathelp() {
    local tmp
    tmp=$(mktemp "${TMPDIR:-/tmp}/bathelp.XXXXXX") || return 1
    cat > "$tmp"
    "$_BAT_CMD" --color=always --style=plain --language=help --paging=never "$tmp"
    rm -f "$tmp"
  }
  chelp() {
    if _cursor_agent_shell; then
      command "$@" --help 2>&1
      return
    fi
    command "$@" --help 2>&1 | bathelp
  }
  # Wrappers that inject flags must pass --help through unchanged; bat colors via global alias below.
  _bat_has_help_flag() {
    local arg
    for arg in "$@"; do
      [[ $arg == --help ]] && return 0
    done
    return 1
  }
  if ! _cursor_agent_shell; then
    alias -g -- '--help=--help 2>&1 | bathelp'
  fi
elif [[ -n ${_BAT_CMD:-} ]]; then
  chelp() { command "$@" --help 2>&1; }
fi
