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
# Base folder for history-here per-project isolation (e.g., _customers/<project>).
(( ! ${+HISTORY_HERE_CUSTOMERS_ROOT} )) && \
  typeset -gr HISTORY_HERE_CUSTOMERS_ROOT="$HOME/Documents/_customers"
# history-here requires a non-empty array; per-project matching is customized after the plugin loads.
export HISTORY_HERE_AUTO_DIRS=("${HISTORY_HERE_CUSTOMERS_ROOT}/")
