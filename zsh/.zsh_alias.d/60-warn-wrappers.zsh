# duf: warn when using df if duf is installed
if command -v duf &>/dev/null; then
  df() {
    if _prefer_tool_hint_skip; then
      command df "$@"
      return
    fi
    _prefer_tool_hint duf
    command df "$@"
  }
fi

# btop: warn when using htop if btop is installed
if command -v btop &>/dev/null; then
  htop() {
    if _prefer_tool_hint_skip; then
      command htop "$@"
      return
    fi
    _prefer_tool_hint btop
    command htop "$@"
  }
fi

# fd/fdfind: warn when using find if a fd binary is installed
if [[ -n ${_FD_CMD:-} ]]; then
  find() {
    if _prefer_tool_hint_skip; then
      command find "$@"
      return
    fi
    _prefer_tool_hint "$_FD_CMD"
    command find "$@"
  }
fi

# gping/mtr: warn when using ping if either is installed
if command -v gping &>/dev/null || command -v mtr &>/dev/null; then
  ping() {
    local -a alts=()
    if _prefer_tool_hint_skip; then
      command ping "$@"
      return
    fi
    command -v mtr &>/dev/null && alts+=(mtr)
    command -v gping &>/dev/null && alts+=(gping)
    (( ${#alts[@]} )) && _prefer_tool_hint "${alts[@]}"
    command ping "$@"
  }
fi
