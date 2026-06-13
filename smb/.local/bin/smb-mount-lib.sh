#!/usr/bin/env bash
# Shared helpers for setup-smb-mount / cleanup-smb-mount (source only).

SMB_CONFIG_DIR="${HOME}/.config/smb"

smb_lib_dir() {
  local src="${BASH_SOURCE[1]:-${BASH_SOURCE[0]}}"
  dirname "$(readlink -f "${src}")"
}

smb_expand_mount_point() {
  local mount_point="$1"
  mount_point="${mount_point//\$\{HOME\}/${HOME}}"
  mount_point="${mount_point/#\~/${HOME}}"
  printf '%s' "${mount_point}"
}

smb_profile_credentials_path() {
  local name="$1"
  printf '%s/%s.credentials' "${SMB_CONFIG_DIR}" "${name}"
}

smb_list_profile_names_from_examples() {
  local example env_name
  shopt -s nullglob
  for example in "${SMB_CONFIG_DIR}"/*.env.example; do
    env_name="$(basename "${example}" .env.example)"
    printf '%s\n' "${env_name}"
  done
  shopt -u nullglob
}

smb_list_profiles() {
  local env_file name
  shopt -s nullglob
  for env_file in "${SMB_CONFIG_DIR}"/*.env; do
    name="$(basename "${env_file}" .env)"
    printf '%s\n' "${name}"
  done
  shopt -u nullglob
}

smb_ensure_profile_files() {
  local created=false
  local name env_file creds_file env_example creds_example

  mkdir -p "${SMB_CONFIG_DIR}"

  while IFS= read -r name; do
    [[ -n "${name}" ]] || continue
    env_file="${SMB_CONFIG_DIR}/${name}.env"
    creds_file="${SMB_CONFIG_DIR}/${name}.credentials"
    env_example="${SMB_CONFIG_DIR}/${name}.env.example"
    creds_example="${SMB_CONFIG_DIR}/${name}.credentials.example"

    if [[ ! -f "${env_file}" ]]; then
      if [[ ! -f "${env_example}" ]]; then
        echo "Missing ${env_file} (no example at ${env_example})."
        exit 1
      fi
      cp "${env_example}" "${env_file}"
      chmod 600 "${env_file}"
      echo "Created ${env_file} from example."
      created=true
    fi

    if [[ ! -f "${creds_file}" ]]; then
      if [[ ! -f "${creds_example}" ]]; then
        echo "Missing ${creds_file} (no example at ${creds_example})."
        exit 1
      fi
      cp "${creds_example}" "${creds_file}"
      chmod 600 "${creds_file}"
      echo "Created ${creds_file} from example."
      created=true
    fi
  done < <(smb_list_profile_names_from_examples)

  if [[ "${created}" == true ]]; then
    echo "Edit the new files under ${SMB_CONFIG_DIR}, then re-run setup-smb-mount."
    exit 1
  fi
}

smb_validate_credentials() {
  local creds="$1"
  if [[ ! -f "${creds}" ]]; then
    echo "Missing credentials file: ${creds}"
    exit 1
  fi
  if ! grep -q '^username=.\+' "${creds}" 2>/dev/null; then
    echo "No username in ${creds}. Edit that file, then re-run."
    exit 1
  fi
  if ! grep -q '^password=.\+' "${creds}" 2>/dev/null; then
    echo "No password in ${creds}. Edit that file, then re-run."
    exit 1
  fi
  chmod 600 "${creds}"
}

smb_credentials_username() {
  local creds="$1"
  grep '^username=' "${creds}" | cut -d= -f2-
}

smb_load_profile() {
  local name="$1"
  local env_file="${SMB_CONFIG_DIR}/${name}.env"

  # shellcheck source=/dev/null
  source "${env_file}"

  : "${SMB_SERVER:?SMB_SERVER not set in ${env_file}}"
  : "${SMB_SHARE:?SMB_SHARE not set in ${env_file}}"

  PROFILE_NAME="${name}"
  PROFILE_ENV_FILE="${env_file}"
  PROFILE_MOUNT_POINT="$(smb_expand_mount_point "${MOUNT_POINT:-${HOME}/${name}}")"
  PROFILE_CREDS="$(smb_expand_mount_point "${SMB_CREDENTIALS:-$(smb_profile_credentials_path "${name}")}")"
  PROFILE_UNIT="$(systemd-escape --path "${PROFILE_MOUNT_POINT}")"
}

smb_fstab_line() {
  local server="$1" share="$2" mount_point="$3" creds="$4" extra_opts="${5:-}"
  local opts="credentials=${creds},uid=$(id -u),gid=$(id -g),file_mode=0644,dir_mode=0755,noperm,iocharset=utf8,vers=3.0,sec=ntlmssp"
  if [[ -n "${extra_opts}" ]]; then
    opts="${opts},${extra_opts}"
  fi
  opts="${opts},x-systemd.automount,nofail,_netdev"
  printf '//%s/%s %s cifs %s 0 0' "${server}" "${share}" "${mount_point}" "${opts}"
}

smb_remove_fstab_entry() {
  local mount_point="$1"
  if grep -qF "${mount_point}" /etc/fstab 2>/dev/null; then
    sudo sed -i "\|${mount_point}|d" /etc/fstab
  fi
}

smb_stop_and_unmount() {
  local mount_point="$1" unit="$2"
  sudo systemctl stop "${unit}.automount" 2>/dev/null || true
  if mountpoint -q "${mount_point}" 2>/dev/null; then
    sudo umount "${mount_point}" 2>/dev/null || sudo umount -l "${mount_point}" 2>/dev/null || true
  fi
}
