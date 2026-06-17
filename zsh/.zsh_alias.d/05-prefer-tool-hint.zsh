# Prefer a modern CLI tool (bold/colored hint, same palette as zsh-you-should-use)
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

  if ! command -v tput &>/dev/null; then
    case ${#tools[@]} in
      1) print -u2 "Consider using ${tools[1]} instead." ;;
      2) print -u2 "Consider using ${tools[1]} or ${tools[2]} instead." ;;
      *)
        local label="${(j:, :)tools}"
        print -u2 "Consider using ${label%%, *} or ${tools[-1]} instead."
        ;;
    esac
    [[ -n $install_hint ]] && print -u2 "Install: $install_hint"
    return
  fi

  local yellow="$(tput bold)$(tput setaf 3)"
  local purple="$(tput setaf 5)"
  local reset="$(tput sgr0)"
  local out="${yellow}Consider using ${reset}"
  local i=1 tool

  for tool in "${tools[@]}"; do
    if (( i > 1 )); then
      if (( i == ${#tools[@]} )); then
        out+="${yellow} or ${reset}"
      else
        out+="${yellow}, ${reset}"
      fi
    fi
    out+="${purple}${tool}${reset}"
    (( i++ ))
  done
  out+="${yellow} instead.${reset}"
  print -u2 "$out"
  [[ -n $install_hint ]] && print -u2 "${yellow}Install:${reset} ${install_hint}"
}
