# Optional apt packages for dotfiles integrations (once per day; skipped under Cursor agent).
if [[ -o interactive ]] && [[ -z ${CURSOR_AGENT:-}${CURSOR_TRACE:-} ]]; then
  typeset -g _dotfiles_deps_check=${HOME}/.local/bin/dotfiles-optional-deps-check
  [[ -x $_dotfiles_deps_check ]] || _dotfiles_deps_check=${HOME}/.dotfiles/zsh/.local/bin/dotfiles-optional-deps-check
  [[ -x $_dotfiles_deps_check ]] && "$_dotfiles_deps_check"
  unset _dotfiles_deps_check
fi
