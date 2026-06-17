# rg: warn when using grep if ripgrep is installed
if command -v rg &>/dev/null; then
  unalias grep fgrep egrep 2>/dev/null
  grep() {
    if _prefer_tool_hint_skip; then
      command grep "$@"
      return
    fi
    _prefer_tool_hint rg
    command grep "$@"
  }
fi
