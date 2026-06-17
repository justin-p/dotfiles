# eza: defaults, SMB/tree ignores, and ls hint when eza is installed
if command -v eza &>/dev/null; then
  # Build ignore list from SMB profiles (~/.config/smb/*.env MOUNT_POINT basenames).
  # Keeps network mounts (nas, homesrv, …) out of listings; avoids slow tree walks in ~.
  _eza_load_smb_ignores() {
    local env_file line mp name
    _EZA_SMB_IGNORES=()
    if [[ -d ${HOME}/.config/smb ]]; then
      for env_file in ${HOME}/.config/smb/*.env(N); do
        line=$(grep -E '^MOUNT_POINT=' "$env_file" | tail -1)
        [[ -z $line ]] && continue
        mp=${line#MOUNT_POINT=}
        mp=${mp//\$\{HOME\}/${HOME}}
        mp=${mp/#\~/${HOME}}
        name=${mp##*/}
        [[ -n $name && ${_EZA_SMB_IGNORES[(Ie)name]} -eq 0 ]] && _EZA_SMB_IGNORES+=("$name")
      done
    fi
    (( ${#_EZA_SMB_IGNORES[@]} )) || _EZA_SMB_IGNORES=(nas)
  }
  _eza_load_smb_ignores

  # True when -T / --tree is present (including combined flags like -Ta).
  _eza_tree_mode() {
    local arg
    for arg in "$@"; do
      case $arg in
        --tree|-T) return 0 ;;
        -[^-]*) [[ $arg == *T* ]] && return 0 ;;
      esac
    done
    return 1
  }

  # True when the user already passed -I / --ignore-glob covering this pattern.
  _eza_user_ignores() {
    local pattern=$1
    shift
    local arg next=0
    for arg in "$@"; do
      if (( next )); then
        [[ $arg == *${pattern}* ]] && return 0
        next=0
        continue
      fi
      case $arg in
        -I*) [[ ${arg#-I} == *${pattern}* ]] && return 0 ;;
        --ignore-glob=*) [[ ${arg#--ignore-glob=} == *${pattern}* ]] && return 0 ;;
        --ignore-glob) next=1 ;;
      esac
    done
    return 1
  }

  # Wrapper: inject default flags and auto-ignores, then forward user args unchanged.
  eza() {
    (( ${+functions[_bat_has_help_flag]} )) && _bat_has_help_flag "$@" && { command eza "$@"; return; }

    local -a eza_args=(--icons=auto --group-directories-first)
    local -a ignore_patterns=()
    local pattern

    # Always skip SMB mount dirs (nas, homesrv, …) unless user passed -I for them.
    for pattern in ${_EZA_SMB_IGNORES[@]}; do
      if ! _eza_user_ignores "$pattern" "$@"; then
        ignore_patterns+=("$pattern")
      fi
    done
    # .git only in tree mode, huge and rarely useful in a directory tree.
    if _eza_tree_mode "$@" && ! _eza_user_ignores '.git' "$@"; then
      ignore_patterns+=('.git')
    fi
    # eza only honors one -I, join patterns with | (multiple -I flags override each other).
    if (( ${#ignore_patterns[@]} )); then
      eza_args+=(-I "${(j:|:)ignore_patterns}")
    fi
    # Long listing, hidden files, git column, column headers.
    eza_args+=(-Alhg --git --header)
    command eza "${eza_args[@]}" "$@"
  }

  unalias ls 2>/dev/null
  # Warn-only ls wrapper; use eza directly for the modern listing.
  ls() {
    if _prefer_tool_hint_skip; then
      command ls "$@"
      return
    fi
    (( ${+functions[_bat_has_help_flag]} )) && _bat_has_help_flag "$@" && {
      command ls --color=auto "$@"
      return
    }
    _prefer_tool_hint eza
    if [[ -x /usr/bin/dircolors ]]; then
      command ls --color=auto "$@"
    else
      command ls "$@"
    fi
  }
fi
