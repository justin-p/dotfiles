zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
if [[ -n ${LS_COLORS:-} ]]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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
  typeset -g _GIT_DELTA_PAGER=${HOME}/.local/bin/git-pager-delta
  [[ -x $_GIT_DELTA_PAGER ]] || _GIT_DELTA_PAGER=${HOME}/.dotfiles/git/.local/bin/git-pager-delta
  zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff -- $word 2>/dev/null | '"${_GIT_DELTA_PAGER}"' --color-only --paging=never'
  zstyle ':fzf-tab:complete:git-(checkout|switch):*' fzf-preview \
    'case $group in
      "modified file") git diff -- $word 2>/dev/null | '"${_GIT_DELTA_PAGER}"' --color-only --paging=never ;;
      "recent commit object name") git show --color=always $word 2>/dev/null | '"${_GIT_DELTA_PAGER}"' --color-only --paging=never ;;
      *) git log -1 --color=always $word 2>/dev/null ;;
    esac'
  zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
    'case $group in
      "commit tag") git show --color=always $word 2>/dev/null ;;
      *) git show --color=always $word 2>/dev/null | '"${_GIT_DELTA_PAGER}"' --color-only --paging=never ;;
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
