
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
# NOTE: FZF_DEFAULT_OPTS is split on spaces — no spaces inside one flag (e.g. --info=inline:… must be one word).
typeset -a _fzf_common_ui=(
  '--info=inline:·'
  '--separator=─'
  '--pointer=▌'
  '--prompt=❯ '
)

# fzf look: Cursor/VS Code based on the 'Bearded Gold D Raynh' theme.
if [[ "$TERM_PROGRAM" == "vscode" ]] || [[ "${(L)TERM_PROGRAM}" == "cursor" ]]; then
  export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border rounded --color=fg:#b8c4e4,bg:#0e1424,hl:#ffd000 --color=fg+:#ffffff,bg+:#131c33,hl+:#e39000 --color=info:#3eb2ff,prompt:#e39000,pointer:#e39000 --color=marker:#21ff7d,spinner:#3eb2ff,header:#2b3d6d --color=border:#2b3f72 ${_fzf_common_ui[@]}"
else
  export FZF_DEFAULT_OPTS="--height 40% --layout reverse --border rounded --color=fg:#d3d7cf,bg:#2e3436,hl:#fce94f --color=fg+:#eeeeec,bg+:#3d4548,hl+:#edd400 --color=info:#729fcf,prompt:#8ae234,pointer:#ad7fa8 --color=marker:#34e2e2,spinner:#729fcf,header:#555753 --color=border:#585a5c ${_fzf_common_ui[@]}"
fi
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

# Set fzf's default command to 'find .' so all files (including dotfiles) are shown by default in fzf
export FZF_DEFAULT_COMMAND='find .'

# Set a custom format for completion descriptions in fzf-tab
zstyle ':completion:*:descriptions' format '[%d]' e

# fzf-tab: inherit theme + prompt layout from FZF_DEFAULT_OPTS (see Aloxaf/fzf-tab README).
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Enable the zsh-autoswitch-virtualenv plugin (fixes a known issue)
enable_autoswitch_virtualenv

# Set PATH so that user-local bin and system binaries come before snap shims.
# This ensures that e.g. Docker uses /usr/bin/docker instead of a possible snap version.
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/snap/bin:$PATH"

# Golang: Add Go binary directory to PATH, so that go and installed programs are found
export PATH=$PATH:/usr/local/go/bin

# FNM (Fast Node Manager): Configure Node.js version manager if directory exists
FNM_PATH="/home/justin-p/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/justin-p/.local/share/fnm:$PATH" # Add fnm binaries to PATH
  eval "`fnm env`"  # Set up FNM environment variables and function wrappers
fi

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun: Add Bun JavaScript runtime binary to PATH
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Enable Bun's shell completions if the completion script exists
[ -s "/home/justin-p/.bun/_bun" ] && source "/home/justin-p/.bun/_bun"

# Source Rust's cargo environment file to update PATH and environment variables (needed for cargo commands)
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
