# history-here: per-project isolation under Documents/_customers (any subfolder name).
if (( $+functions[_history_here_find_auto_root] )); then
  functions[_history_here_find_auto_root_default]=$functions[_history_here_find_auto_root]
  _history_here_find_auto_root() {
    local _customers_root="$HISTORY_HERE_CUSTOMERS_ROOT"
    if [[ "$PWD" == "$_customers_root" ]]; then
      print -r -- ""
      return
    fi
    if [[ "$PWD" == "$_customers_root"/* ]]; then
      local _project="${${PWD#$_customers_root/}%%/*}"
      if [[ -n "$_project" ]]; then
        print -r -- "$_customers_root/$_project"
        return
      fi
    fi
    _history_here_find_auto_root_default
  }
  (( $+functions[_history_here_auto_switch_for_pwd] )) && _history_here_auto_switch_for_pwd
fi
