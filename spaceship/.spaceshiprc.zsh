# Spaceship config

SPACESHIP_PROMPT_ASYNC=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_PROMPT_SEPARATE_LINE=true
SPACESHIP_PROMPT_DEFAULT_PREFIX=""

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX=""
SPACESHIP_TIME_SUFFIX=" "
SPACESHIP_TIME_COLOR="blue"

SPACESHIP_USER_SHOW=always
SPACESHIP_USER_PREFIX=""
SPACESHIP_USER_SUFFIX=" "
SPACESHIP_USER_COLOR="magenta"
SPACESHIP_HOST_PREFIX="@"
SPACESHIP_HOST_SUFFIX=" "
SPACESHIP_HOST_COLOR="blue"
SPACESHIP_HOST_COLOR_SSH="green"

SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_SUFFIX=" "
SPACESHIP_DIR_COLOR="cyan"

SPACESHIP_GIT_PREFIX=""
SPACESHIP_GIT_SUFFIX=" "
SPACESHIP_GIT_BRANCH_COLOR="magenta"

# Git subsection order: branch, working-tree status (ahead/behind, dirty), then short HEAD hash.
SPACESHIP_GIT_ORDER=(git_branch git_status git_commit)
SPACESHIP_GIT_STATUS_SHOW=true
SPACESHIP_GIT_COMMIT_SHOW=true
SPACESHIP_GIT_COMMIT_COLOR="yellow"

SPACESHIP_EXEC_TIME_PREFIX=""
SPACESHIP_EXEC_TIME_SUFFIX=""
SPACESHIP_EXEC_TIME_COLOR="yellow"
SPACESHIP_EXEC_TIME_ELAPSED=1
SPACESHIP_RPROMPT_ORDER=(exec_time)

SPACESHIP_PROMPT_ORDER=(
  time user dir host git hg package haxe node rlang bun deno ruby python red elm elixir xcode xcenv swift swiftenv golang perl php rust haskell scala kotlin java lua dart julia crystal docker docker_compose aws gcloud azure venv conda uv dotnet ocaml vlang zig purescript erlang gleam kubectl ansible terraform pulumi ibmcloud nix_shell gnu_screen async line_sep battery jobs exit_code sudo char
)

SPACESHIP_CHAR_PREFIX=""
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_CHAR_SYMBOL="$ "
SPACESHIP_CHAR_SYMBOL_ROOT="# "
SPACESHIP_CHAR_COLOR_SUCCESS="green"
SPACESHIP_CHAR_COLOR_FAILURE="red"
