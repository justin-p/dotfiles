# Shared stderr formatter: dotfiles: <label>: <details>
_dotfiles_msg() {
  local label=$1
  shift
  if ! command -v tput &>/dev/null || [[ -z ${TERM:-} ]]; then
    if (( $# )); then
      print -u2 "dotfiles: ${label}: $*"
    else
      print -u2 "dotfiles: ${label}:"
    fi
    return
  fi

  local yb="$(tput bold)$(tput setaf 3)"
  local y="$(tput setaf 3)"
  local r="$(tput sgr0)"
  if (( $# )); then
    print -u2 "${yb}dotfiles:${r} ${y}${label}:${r} $*"
  else
    print -u2 "${yb}dotfiles:${r} ${y}${label}:${r}"
  fi
}
