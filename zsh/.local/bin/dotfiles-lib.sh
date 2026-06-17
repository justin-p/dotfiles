#!/usr/bin/env bash
# Shared helpers for dotfiles scripts (messages, sync detection/fix).
# Sets (sync): DOTFILES_SYNC_ROOT, DOTFILES_SYNC_DIRTY_COUNT, DOTFILES_SYNC_BEHIND,
#              DOTFILES_SYNC_AHEAD, DOTFILES_SYNC_UPSTREAM, DOTFILES_SYNC_UNSTOWED_PKGS,
#              DOTFILES_SYNC_ISSUES

dotfiles_colors() {
  if command -v tput &>/dev/null && [[ -n ${TERM:-} ]]; then
    DOTFILES_YB="$(tput bold)$(tput setaf 3)"
    DOTFILES_Y="$(tput setaf 3)"
    DOTFILES_R="$(tput sgr0)"
  else
    DOTFILES_YB=
    DOTFILES_Y=
    DOTFILES_R=
  fi
}

# Usage: dotfiles_msg label [details]
# Prints: dotfiles: <label>: <details>  (label yellow; details plain)
dotfiles_msg() {
  local label=$1
  shift
  dotfiles_colors
  if (( $# )); then
    printf '%s\n' "${DOTFILES_YB}dotfiles:${DOTFILES_R} ${DOTFILES_Y}${label}:${DOTFILES_R} $*" >&2
  else
    printf '%s\n' "${DOTFILES_YB}dotfiles:${DOTFILES_R} ${DOTFILES_Y}${label}:${DOTFILES_R}" >&2
  fi
}

dotfiles_sync_detect() {
  local fetch=${1:-1}
  local root dirty dirty_count upstream counts behind ahead
  local search maxdepth link target pkg line
  local -A stowed_pkgs=()
  local -A unstowed_seen=()

  DOTFILES_SYNC_ROOT=${DOTFILES_ROOT:-$HOME/.dotfiles}
  DOTFILES_SYNC_ROOT=$(cd "$DOTFILES_SYNC_ROOT" 2>/dev/null && pwd) || return 1
  git -C "$DOTFILES_SYNC_ROOT" rev-parse --git-dir &>/dev/null || return 1

  DOTFILES_SYNC_DIRTY_COUNT=0
  DOTFILES_SYNC_BEHIND=0
  DOTFILES_SYNC_AHEAD=0
  DOTFILES_SYNC_UPSTREAM=
  DOTFILES_SYNC_UNSTOWED_PKGS=()
  DOTFILES_SYNC_ISSUES=()

  root=$DOTFILES_SYNC_ROOT

  if dirty=$(git -C "$root" status --porcelain 2>/dev/null) && [[ -n $dirty ]]; then
    dirty_count=$(wc -l <<<"$dirty")
    DOTFILES_SYNC_DIRTY_COUNT=$dirty_count
    DOTFILES_SYNC_ISSUES+=("uncommitted changes ($dirty_count file(s))")
  fi

  upstream=$(git -C "$root" rev-parse --abbrev-ref @{u} 2>/dev/null) || upstream=
  DOTFILES_SYNC_UPSTREAM=$upstream
  if [[ -n $upstream ]]; then
    if [[ $fetch == 1 ]]; then
      git -C "$root" fetch --quiet "${upstream%%/*}" 2>/dev/null
    fi
    if counts=$(git -C "$root" rev-list --left-right --count HEAD...@{u} 2>/dev/null); then
      read -r ahead behind <<<"$counts"
      DOTFILES_SYNC_BEHIND=$behind
      DOTFILES_SYNC_AHEAD=$ahead
      (( behind )) && DOTFILES_SYNC_ISSUES+=("behind $upstream by $behind commit(s)")
      (( ahead )) && DOTFILES_SYNC_ISSUES+=("ahead of $upstream by $ahead commit(s)")
    fi
  fi

  _dotfiles_sync_pkg_from_link() {
    local t=$1 p=
    if [[ $t == /* ]]; then
      [[ $t == "$root/"* ]] || return 1
      p=${t#"$root"/}
    elif [[ $t == *".dotfiles/"* ]]; then
      p=${t#*".dotfiles/"}
    else
      return 1
    fi
    p=${p%%/*}
    [[ -n $p ]] || return 1
    printf '%s' "$p"
  }

  for search in "$HOME" "$HOME/.config" "$HOME/.local/bin"; do
    [[ -d $search ]] || continue
    if [[ $search == "$HOME" ]]; then
      maxdepth=1
    elif [[ $search == "$HOME/.local/bin" ]]; then
      maxdepth=2
    else
      maxdepth=6
    fi
    while IFS= read -r -d '' link; do
      target=$(readlink "$link" 2>/dev/null) || continue
      pkg=$(_dotfiles_sync_pkg_from_link "$target") || continue
      stowed_pkgs[$pkg]=1
    done < <(find "$search" -maxdepth "$maxdepth" -type l -print0 2>/dev/null)
  done

  if (( ${#stowed_pkgs[@]} )); then
    while IFS= read -r line; do
      [[ $line == LINK:* ]] || continue
      pkg=$(_dotfiles_sync_pkg_from_link "${line#*=> }") || continue
      [[ -n ${unstowed_seen[$pkg]+x} ]] && continue
      unstowed_seen[$pkg]=1
      DOTFILES_SYNC_UNSTOWED_PKGS+=("$pkg")
    done < <(cd "$root" && stow -n -v "${!stowed_pkgs[@]}" 2>&1)
  fi

  if (( ${#DOTFILES_SYNC_UNSTOWED_PKGS[@]} )); then
    DOTFILES_SYNC_ISSUES+=("unstowed packages: ${DOTFILES_SYNC_UNSTOWED_PKGS[*]}")
  fi

  return 0
}

dotfiles_sync_commit_msg() {
  printf '%s' "${DOTFILES_SYNC_COMMIT_MSG:-chore(dotfiles): sync local changes}"
}

dotfiles_sync_ahead_count() {
  local counts ahead=0 behind=0
  [[ -n ${DOTFILES_SYNC_UPSTREAM:-} ]] || return 0
  counts=$(git -C "$DOTFILES_SYNC_ROOT" rev-list --left-right --count HEAD...@{u} 2>/dev/null) || return 0
  read -r ahead behind <<<"$counts"
  printf '%s' "$ahead"
}

dotfiles_sync_fix_plan() {
  local root=$DOTFILES_SYNC_ROOT
  local msg
  msg=$(dotfiles_sync_commit_msg)

  if (( ${#DOTFILES_SYNC_UNSTOWED_PKGS[@]} )); then
    printf 'cd %q && stow %s\n' "$root" "${DOTFILES_SYNC_UNSTOWED_PKGS[*]}"
  fi
  if (( DOTFILES_SYNC_DIRTY_COUNT )); then
    printf 'cd %q && git add -A && git commit -m %q\n' "$root" "$msg"
  fi
  if (( DOTFILES_SYNC_BEHIND )); then
    printf 'cd %q && git pull\n' "$root"
  fi
  if [[ -n $DOTFILES_SYNC_UPSTREAM ]] && (( DOTFILES_SYNC_AHEAD || DOTFILES_SYNC_DIRTY_COUNT )); then
    printf 'cd %q && git push\n' "$root"
  fi
}
