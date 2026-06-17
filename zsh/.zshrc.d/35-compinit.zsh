# Completion cache: compinit -C for speed; full compinit every ZSH_COMPINIT_REFRESH_DAYS (default 7).
autoload -Uz compinit

typeset -g _zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
typeset -g _zcompdump_stamp="${_zcompdump}.refresh.stamp"
typeset -g _zcompdump_refresh_days=${ZSH_COMPINIT_REFRESH_DAYS:-7}

mkdir -p "${_zcompdump:h}"

_zcompdump_now() {
  if (( ${+EPOCHSECONDS} )); then
    print -r -- $EPOCHSECONDS
  else
    date +%s
  fi
}

_zcompdump_needs_refresh() {
  [[ ${ZSH_COMPINIT_REFRESH_FORCE:-} == 1 ]] && return 0
  [[ ! -s $_zcompdump_stamp ]] && return 0
  local then=${$(<"$_zcompdump_stamp"):-0}
  (( then > 0 && (_zcompdump_now - then) / 86400 < _zcompdump_refresh_days )) && return 1
  return 0
}

if _zcompdump_needs_refresh; then
  local _zcompdump_reason=scheduled
  [[ ${ZSH_COMPINIT_REFRESH_FORCE:-} == 1 ]] && _zcompdump_reason=forced
  [[ ! -s $_zcompdump_stamp ]] && _zcompdump_reason=initial

  rm -f "$_zcompdump"(N) "${_zcompdump}.zwc"(N) 2>/dev/null
  compinit -d "$_zcompdump"
  _zcompdump_now >|"$_zcompdump_stamp"

  if command -v tput &>/dev/null && [[ -n ${TERM:-} ]]; then
    local yellow="$(tput setaf 3)$(tput bold)" reset="$(tput sgr0)"
    print -u2 "${yellow}dotfiles:${reset} rebuilt zsh completion cache (${_zcompdump_reason}; next refresh in ${_zcompdump_refresh_days} day(s))"
  else
    print -u2 "dotfiles: rebuilt zsh completion cache (${_zcompdump_reason}; next refresh in ${_zcompdump_refresh_days} day(s))"
  fi
  unset _zcompdump_reason
else
  compinit -C -d "$_zcompdump"
fi

unset -f _zcompdump_needs_refresh _zcompdump_now
unset _zcompdump _zcompdump_stamp _zcompdump_refresh_days
