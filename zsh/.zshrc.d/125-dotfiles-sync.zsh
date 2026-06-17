# Dotfiles git/stow sync check (once per day; skipped under Cursor agent).
if [[ -o interactive ]] && [[ -z ${CURSOR_AGENT:-}${CURSOR_TRACE:-} ]]; then
  typeset -g _dotfiles_sync_check=${HOME}/.local/bin/dotfiles-sync-check
  [[ -x $_dotfiles_sync_check ]] || _dotfiles_sync_check=${HOME}/.dotfiles/zsh/.local/bin/dotfiles-sync-check
  [[ -x $_dotfiles_sync_check ]] && "$_dotfiles_sync_check"
  unset _dotfiles_sync_check
fi
