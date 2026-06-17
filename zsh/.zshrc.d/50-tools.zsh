# fd / fdfind (Debian/Ubuntu ship the binary as fdfind)
typeset -g _FD_CMD=
if command -v fd &>/dev/null; then
  _FD_CMD=fd
elif command -v fdfind &>/dev/null; then
  _FD_CMD=fdfind
fi

# bat / batcat (Debian/Ubuntu ship the binary as batcat)
typeset -g _BAT_CMD=
if command -v bat &>/dev/null; then
  _BAT_CMD=bat
elif command -v batcat &>/dev/null; then
  _BAT_CMD=batcat
  alias bat=batcat
fi

# fzf-file-preview path (Ctrl+T, fzf-tab, zoxide zi)
typeset -g _FZF_FILE_PREVIEW=${HOME}/.local/bin/fzf-file-preview
[[ -x $_FZF_FILE_PREVIEW ]] || _FZF_FILE_PREVIEW=${HOME}/.dotfiles/fzf/.local/bin/fzf-file-preview

if [[ -n ${_BAT_CMD:-} ]]; then
  # Rebuild bat cache when custom themes/syntaxes change (required for BAT_THEME and --language=help).
  local _bat_config=${XDG_CONFIG_HOME:-$HOME/.config}/bat
  local _bat_cache=${XDG_CACHE_HOME:-$HOME/.cache}/bat/syntaxes.bin
  if [[ -d $_bat_config/themes || -d $_bat_config/syntaxes ]] && {
    [[ ! -f $_bat_cache ]] ||
    find "$_bat_config"/{themes,syntaxes} \( -name '*.tmTheme' -o -name '*.sublime-syntax' \) \
      -newer "$_bat_cache" -print -quit 2>/dev/null | grep -q .
  }; then
    "$_BAT_CMD" cache --build &>/dev/null
  fi
  # --language=help is optional; only pipe --help through bat when bat lists it.
  typeset -g _BAT_HELP_OK=
  "$_BAT_CMD" --list-languages 2>/dev/null | grep -qE '(^|:|,)(cmd-help|help)(,|$)' && _BAT_HELP_OK=1
  # https://github.com/sharkdp/bat#integration-with-other-tools
  export MANPAGER="${_BAT_CMD} -plman"
  if [[ -x $_FZF_FILE_PREVIEW ]]; then
    export FZF_CTRL_T_OPTS="--preview-window=right:55%,border-rounded --preview=${_FZF_FILE_PREVIEW}\ {}"
  fi
  # --help → bat: global alias in ~/.zsh_alias.d/20-bat.zsh (https://github.com/sharkdp/bat#highlighting---help-messages)
fi
