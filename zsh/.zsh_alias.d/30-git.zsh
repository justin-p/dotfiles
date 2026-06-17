# better-commits git wrapper (disabled under Cursor agent shells)
git() {
  if _cursor_agent_shell; then
    command git "$@"
    return
  fi

  (( ${+functions[_bat_has_help_flag]} )) && _bat_has_help_flag "$@" && { command git "$@"; return; }

  if [[ "$1" == "commit" && $# -eq 1 ]] || [[ "$1" == "add" && $# -eq 1 ]]; then
    if command -v better-commits &>/dev/null; then
      better-commits
    else
      _prefer_tool_hint better-commits --install 'npm install -g better-commits'
      command git "$@"
    fi
  else
    command git "$@"
  fi
}

alias gs='git status'  # overwrites ghostscript (use command gs if needed)
