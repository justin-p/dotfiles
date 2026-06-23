#!/usr/bin/env bash
# Shared helpers for copyparty-webdav mount scripts (source only).

COPYPARTY_CONFIG_DIR="${HOME}/.config/copyparty-webdav"
COPYPARTY_ENV="${COPYPARTY_CONFIG_DIR}/env"
COPYPARTY_CREDS="${COPYPARTY_CONFIG_DIR}/credentials"

copyparty_lib_dir() {
  local src="${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}"
  dirname "$(readlink -f "${src}")"
}

copyparty_expand_home() {
  local value="$1"
  value="${value//\$\{HOME\}/${HOME}}"
  value="${value/#\~/${HOME}}"
  printf '%s' "${value}"
}

copyparty_ensure_config_files() {
  local created=false

  mkdir -p "${COPYPARTY_CONFIG_DIR}"

  if [[ ! -f "${COPYPARTY_ENV}" ]]; then
    if [[ ! -f "${COPYPARTY_CONFIG_DIR}/env.example" ]]; then
      echo "Missing ${COPYPARTY_ENV} (no example file)."
      exit 1
    fi
    cp "${COPYPARTY_CONFIG_DIR}/env.example" "${COPYPARTY_ENV}"
    chmod 600 "${COPYPARTY_ENV}"
    echo "Created ${COPYPARTY_ENV} from example."
    created=true
  fi

  if [[ ! -f "${COPYPARTY_CREDS}" ]]; then
    if [[ ! -f "${COPYPARTY_CONFIG_DIR}/credentials.example" ]]; then
      echo "Missing ${COPYPARTY_CREDS} (no example file)."
      exit 1
    fi
    cp "${COPYPARTY_CONFIG_DIR}/credentials.example" "${COPYPARTY_CREDS}"
    chmod 600 "${COPYPARTY_CREDS}"
    echo "Created ${COPYPARTY_CREDS} from example."
    created=true
  fi

  if [[ "${created}" == true ]]; then
    echo "Edit ${COPYPARTY_ENV} and ${COPYPARTY_CREDS}, then re-run setup-copyparty-webdav."
    exit 0
  fi
}

copyparty_load_config() {
  # shellcheck disable=SC1090
  source "${COPYPARTY_ENV}"

  WEBDAV_URL="${WEBDAV_URL:?WEBDAV_URL not set in ${COPYPARTY_ENV}}"
  MOUNT_POINT="$(copyparty_expand_home "${MOUNT_POINT:?MOUNT_POINT not set in ${COPYPARTY_ENV}}")"
  RCLONE_REMOTE="${RCLONE_REMOTE:-copyparty-webdav}"
  RCLONE="${RCLONE:-${HOME}/.local/bin/rclone}"
  LOG="${HOME}/.local/share/rclone-${RCLONE_REMOTE}.log"
  RCLONE_LOG_LEVEL="${RCLONE_LOG_LEVEL:-NOTICE}"
  RCLONE_LOG_MAX_SIZE="${RCLONE_LOG_MAX_SIZE:-10M}"
  RCLONE_LOG_MAX_AGE="${RCLONE_LOG_MAX_AGE:-7d}"
  RCLONE_LOG_MAX_BACKUPS="${RCLONE_LOG_MAX_BACKUPS:-3}"

  local username password
  # shellcheck disable=SC1090
  source "${COPYPARTY_CREDS}"
  WEBDAV_USER="${username:?username not set in ${COPYPARTY_CREDS}}"
  WEBDAV_PASS="${password:?password not set in ${COPYPARTY_CREDS}}"
}

copyparty_validate_rclone() {
  if [[ ! -x "${RCLONE}" ]]; then
    echo "rclone not found at ${RCLONE}."
    echo "Run setup-copyparty-webdav to install it, or place rclone on PATH."
    exit 1
  fi
}
