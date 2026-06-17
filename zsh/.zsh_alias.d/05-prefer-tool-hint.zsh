# Prefer a modern CLI tool (dotfiles unified message format)
# Usage: _prefer_tool_hint tool [tool ...] [--install 'install command']
_prefer_tool_hint() {
  local -a tools=()
  local install_hint= arg

  while (( $# )); do
    if [[ $1 == --install ]]; then
      shift
      (( $# )) || return 0
      install_hint=$1
    else
      tools+=("$1")
    fi
    shift
  done
  (( ${#tools[@]} )) || return

  local label
  case ${#tools[@]} in
    1) label=$tools[1] ;;
    2) label="${tools[1]} or ${tools[2]}" ;;
    *)
      label="${(j:, :)tools}"
      label="${label%%, *} or ${tools[-1]}"
      ;;
  esac

  _dotfiles_msg "consider using" "$label"
  [[ -n $install_hint ]] && _dotfiles_msg install "$install_hint"
}
