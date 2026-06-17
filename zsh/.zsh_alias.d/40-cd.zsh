# zoxide: remap cd -> z; bare cd opens interactive picker (zi)
cd() {
  if _cursor_agent_shell; then
    builtin cd "$@"
    return
  fi

  if (( $# == 0 )); then
    if (( ${+functions[zi]} )); then
      zi
    else
      builtin cd ~
    fi
    return
  fi

  if (( ${+functions[z]} )); then
    z "$@"
  else
    builtin cd "$@"
  fi
}
