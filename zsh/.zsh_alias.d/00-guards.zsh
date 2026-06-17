_cursor_agent_shell() { [[ -n ${CURSOR_AGENT:-} || -n ${CURSOR_TRACE:-} ]]; }

# Skip prefer-tool hints during config sourcing and under Cursor agent shells.
_prefer_tool_hint_skip() {
  _cursor_agent_shell || [[ $ZSH_EVAL_CONTEXT == *:file:* ]]
}
