
# Load the Zsh completion system (autoloads the completion function)
autoload -Uz compinit

# Enable interactive menu completion (use arrow keys to choose completions)
zstyle ':completion:*' menu select

# Add ~/.zfunc directory to fpath, so Zsh can find custom function definitions (e.g., plugin completions)
fpath+=~/.zfunc

# History: set HISTFILE, sizes, and HISTORY_HERE_AUTO_DIRS *before* antidote loads history-here.
setopt EXTENDED_HISTORY                 # Record timestamp of each command in history
setopt HIST_EXPIRE_DUPS_FIRST           # When trimming history, expire duplicate entries first
setopt HIST_IGNORE_DUPS                 # Ignore consecutive duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS             # Remove all duplicate commands from history (keep only the latest)
setopt HIST_IGNORE_SPACE                # Don't save commands that start with a space character
setopt HIST_FIND_NO_DUPS                # When searching history, don't show duplicate matches
setopt HIST_SAVE_NO_DUPS                # Don't write duplicate entries to the history file
setopt HIST_BEEP                        # Beep if no match is found during a history search
setopt INC_APPEND_HISTORY               # Write new history lines to HISTFILE as each command finishes
setopt SHARE_HISTORY                    # Share new lines across concurrent interactive shells
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
export HISTORY_HERE_AUTO_DIRS=(/home/justin-p/Documents/_customers/ )

# Check if the Antidote plugin manager is installed in ~/.antidote (or $ZDOTDIR/.antidote), clone if missing
[[ -e ${ZDOTDIR:-~}/.antidote ]] || \
  git clone https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# Source Antidote's main script to enable plugin bundling features
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Initialize Antidote's plugin system (loads plugin manager configuration)
source <(antidote init)

# Load all plugins listed in ~/.zsh_plugins (one per line)
antidote bundle < ~/.zsh_plugins

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
if [[ -n ${_BAT_CMD:-} ]]; then
  # https://github.com/sharkdp/bat#integration-with-other-tools
  typeset -g _FZF_FILE_PREVIEW=${HOME}/.local/bin/fzf-file-preview
  [[ -x $_FZF_FILE_PREVIEW ]] || _FZF_FILE_PREVIEW=${HOME}/.dotfiles/fzf/.local/bin/fzf-file-preview
  export MANPAGER="${_BAT_CMD} -plman"
  if [[ -x $_FZF_FILE_PREVIEW ]]; then
    export FZF_CTRL_T_OPTS="--preview-window=right:55%,border-rounded --preview=${_FZF_FILE_PREVIEW}\ {}"
  fi
  # --help → bat: global alias in ~/.zsh_alias (https://github.com/sharkdp/bat#highlighting---help-messages)
fi

# Source a file containing custom aliases if it exists (~/.zsh_alias)
[ -f ~/.zsh_alias ] && source ~/.zsh_alias

# Check if tmux tpm is installed, if not clone and install
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Check if fzf is not installed in $HOME/.fzf; if not, clone and install it with bindings and completion
if [[ ! -d "$HOME/.fzf" ]]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc
fi

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

## helper function to check which comsic terminal theme is being used
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
  [[ -n ${_BAT_CMD:-} ]] && export BAT_THEME=Bearded-Gold-D-Raynh
else
  export FZF_DEFAULT_OPTS="--height 70% --min-height 15+ --layout reverse --border rounded --color=fg:#d3d7cf,bg:#2e3436,hl:#fce94f --color=fg+:#eeeeec,bg+:#3d4548,hl+:#edd400 --color=info:#729fcf,prompt:#8ae234,pointer:#ad7fa8 --color=marker:#34e2e2,spinner:#729fcf,header:#555753 --color=border:#585a5c ${_fzf_common_ui[@]}"
  [[ -n ${_BAT_CMD:-} ]] && export BAT_THEME=TwoDark
fi
unset -f _cosmic_term_active _cosmic_term_theme_is
unset _fzf_common_ui

# Source the fzf zsh integration script if it exists, enabling key bindings & tab completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ctrl+Left / Ctrl+Right: many terminals send CSI 1;5D / 1;5C. Without bindkey, zsh can echo ";5C" etc.
() {
  local km
  for km in emacs viins vicmd; do
    bindkey -M "$km" $'\e[1;5D' backward-word
    bindkey -M "$km" $'\e[1;5C' forward-word
  done
}

# fzf: fd/fdfind when installed (hidden files, follows symlinks); else find
if [[ -n ${_FD_CMD:-} ]]; then
  export FZF_DEFAULT_COMMAND="$_FD_CMD --hidden --follow --exclude .git"
else
  export FZF_DEFAULT_COMMAND='find .'
fi

# Set a custom format for completion descriptions in fzf-tab
zstyle ':completion:*:descriptions' format '[%d]' e

# fzf-tab: inherit theme + prompt layout from FZF_DEFAULT_OPTS (see Aloxaf/fzf-tab README).
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:*' fzf-preview-window 'right:55%,border-rounded'

# Paths / files
if [[ -x ${_FZF_FILE_PREVIEW:-} ]]; then
  zstyle ':fzf-tab:complete:*:*' fzf-preview \
    '[[ -e ${(Q)realpath} ]] && '"${_FZF_FILE_PREVIEW}"' ${(Q)realpath}'
fi

# man (uses MANPAGER → bat when installed)
zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview \
  'MANWIDTH=${FZF_PREVIEW_COLUMNS} man $word 2>/dev/null'

# kill / ps — show full command line for the selected PID
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o pid,user,cmd --no-headers -w -w 2>/dev/null'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:5:wrap

# git — diffs, commits, branches (delta when installed)
if command -v delta &>/dev/null; then
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff -- $word 2>/dev/null | delta --color-only --paging=never'
  zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
    'case $group in
      "modified file") git diff -- $word 2>/dev/null | delta --color-only --paging=never ;;
      "recent commit object name") git show --color=always $word 2>/dev/null | delta --color-only --paging=never ;;
      *) git log -1 --color=always $word 2>/dev/null ;;
    esac'
  zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'case $group in
      "commit tag") git show --color=always $word 2>/dev/null ;;
      *) git show --color=always $word 2>/dev/null | delta --color-only --paging=never ;;
    esac'
else
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff -- $word 2>/dev/null'
  zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
    'case $group in
      "modified file") git diff -- $word 2>/dev/null ;;
      "recent commit object name") git show --color=always $word 2>/dev/null ;;
      *) git log -1 --color=always $word 2>/dev/null ;;
    esac'
  zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'git show --color=always $word 2>/dev/null'
fi
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
  'git log -1 --color=always $word 2>/dev/null'
if [[ -n ${_BAT_CMD:-} ]]; then
  zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
    'git help $word 2>/dev/null | '"${_BAT_CMD}"' -plman --color=always --paging=never'
fi

# Enable the zsh-autoswitch-virtualenv plugin (fixes a known issue)
enable_autoswitch_virtualenv

# Set PATH so that user-local bin and system binaries come before snap shims.
# This ensures that e.g. Docker uses /usr/bin/docker instead of a possible snap version.
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/snap/bin:$PATH"

# Golang: Set GOROOT and add Go binary directory to PATH
if [ -d /usr/local/go ]; then
  export GOROOT=/usr/local/go
  export PATH="$PATH:$GOROOT/bin"
fi

# FNM (Fast Node Manager)
if [[ -d "$HOME/.local/share/fnm" ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

# Node Version Manager
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Bun: Add Bun JavaScript runtime binary to PATH
if [ -d "$HOME/.bun/bin" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
fi

# Source Rust's cargo environment file to update PATH and environment variables (needed for cargo commands)
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# zoxide: init after ~/.cargo/bin is on PATH
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Optional apt packages for dotfiles integrations (once per day; skipped under Cursor agent).
if [[ -o interactive ]] && [[ -z ${CURSOR_AGENT:-}${CURSOR_TRACE:-} ]]; then
  typeset -g _dotfiles_deps_check=${HOME}/.local/bin/dotfiles-optional-deps-check
  [[ -x $_dotfiles_deps_check ]] || _dotfiles_deps_check=${HOME}/.dotfiles/zsh/.local/bin/dotfiles-optional-deps-check
  [[ -x $_dotfiles_deps_check ]] && "$_dotfiles_deps_check"
  unset _dotfiles_deps_check
fi
