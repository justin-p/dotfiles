# better-commits git wrapper (disabled under Cursor agent shells)
_has_better_commits() {
  command -v better-commits &>/dev/null && return 0
  command -v fnm &>/dev/null && fnm exec -- command -v better-commits &>/dev/null
}

git() {
  if _cursor_agent_shell; then
    command git "$@"
    return
  fi

  (( ${+functions[_bat_has_help_flag]} )) && _bat_has_help_flag "$@" && { command git "$@"; return; }

  if [[ "$1" == "commit" && $# -eq 1 ]] || [[ "$1" == "add" && $# -eq 1 ]]; then
    if _has_better_commits; then
      if command -v better-commits &>/dev/null; then
        better-commits
      else
        fnm exec -- better-commits
      fi
    else
      _prefer_tool_hint better-commits --install 'fnm install --lts && npm install -g better-commits'
      command git "$@"
    fi
  else
    command git "$@"
  fi
}

alias gs='git status'  # overwrites ghostscript (use command gs if needed)
