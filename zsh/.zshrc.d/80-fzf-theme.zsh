# fzf prompt/info layout: shared by vanilla fzf (Ctrl+R, ** …) and fzf-tab (use-fzf-default-opts).
# NOTE: FZF_DEFAULT_OPTS is split on spaces. No spaces inside one flag (e.g. --info=inline:… must be one word).
typeset -a _fzf_common_ui=(
  '--ansi'
  '--info=inline:·'
  '--separator=─'
  '--pointer=▌'
  '--prompt=❯ '
)
export FZF_TMUX_HEIGHT=70%   # Ctrl+T / Alt+C (fzf key-bindings default is 40%)

# fzf look: Cursor/VS Code and COSMIC Terminal, Bearded Theme feat. Gold D Raynh.
## helper function to check if cosmic terminal is being used
_cosmic_term_active() {
  local pid=$PPID comm
  while [[ -n "$pid" && "$pid" -gt 1 ]]; do
    [[ -r "/proc/$pid/comm" ]] || return 1
    comm=$(<"/proc/$pid/comm")
    [[ "$comm" == cosmic-term ]] && return 0
    pid=$(awk '/^PPid:/ { print $2; exit }' "/proc/$pid/status" 2>/dev/null) || return 1
  done
  return 1
}

## helper function to check which cosmic terminal theme is being used
_cosmic_term_theme_is() {
  local theme_name="$1"
  local quoted="\"${theme_name}\""
  local cfg_dir="${XDG_CONFIG_HOME:-$HOME/.config}/cosmic/com.system76.CosmicTerm/v1"
  local theme_file content

  for theme_file in \
    "${cfg_dir}/syntax_theme_dark" \
    "${cfg_dir}/syntax_theme_light"; do
    [[ -f "$theme_file" ]] || continue
    content=$(<"$theme_file")
    [[ "$content" == "$quoted" ]] && return 0
  done

  [[ -f "${cfg_dir}/profiles" ]] && \
    grep -qF "syntax_theme_dark: ${quoted}" "${cfg_dir}/profiles" && return 0
  [[ -f "${cfg_dir}/profiles" ]] && \
    grep -qF "syntax_theme_light: ${quoted}" "${cfg_dir}/profiles"

  return $?
}

## Change color of FZF to match Bearded Theme feat. Gold D Raynh when relevant, otherwise, match the default PopOS non cosmic terminal
if [[ "$TERM_PROGRAM" == "vscode" || "${(L)TERM_PROGRAM}" == "cursor" ]] || { _cosmic_term_active && _cosmic_term_theme_is 'Bearded Theme feat. Gold D Raynh'; }; then
  export FZF_DEFAULT_OPTS="--height 70% --min-height 15+ --layout reverse --border rounded --color=fg:#b8c4e4,bg:#0e1424,hl:#ffd000 --color=fg+:#ffffff,bg+:#131c33,hl+:#e39000 --color=info:#3eb2ff,prompt:#e39000,pointer:#e39000 --color=marker:#21ff7d,spinner:#3eb2ff,header:#2b3d6d --color=border:#2b3f72 ${_fzf_common_ui[@]}"
  if [[ -n ${_BAT_CMD:-} ]] && "$_BAT_CMD" --list-themes 2>/dev/null | grep -qx 'Bearded-Gold-D-Raynh'; then
    export BAT_THEME=Bearded-Gold-D-Raynh
  else
    unset BAT_THEME
  fi
else
  export FZF_DEFAULT_OPTS="--height 70% --min-height 15+ --layout reverse --border rounded --color=fg:#d3d7cf,bg:#2e3436,hl:#fce94f --color=fg+:#eeeeec,bg+:#3d4548,hl+:#edd400 --color=info:#729fcf,prompt:#8ae234,pointer:#ad7fa8 --color=marker:#34e2e2,spinner:#729fcf,header:#555753 --color=border:#585a5c ${_fzf_common_ui[@]}"
  if [[ -n ${_BAT_CMD:-} ]] && "$_BAT_CMD" --list-themes 2>/dev/null | grep -qx 'TwoDark'; then
    export BAT_THEME=TwoDark
  else
    unset BAT_THEME
  fi
fi
unset -f _cosmic_term_active _cosmic_term_theme_is
unset _fzf_common_ui
