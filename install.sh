#!/bin/sh
set -e

# ============================================================
# Configuration
# ============================================================

INSTALL_ROOT="/userdata/system"
STACK_DIR_NAME="mesa-vulkan-25.3.0-1.4.328.1"
INSTALL_DIR="${INSTALL_ROOT}/${STACK_DIR_NAME}"

# GitHub release asset (tarball built by releases/tar.sh)
STACK_URL="${STACK_URL:-https://github.com/tbrautaset/rpi-batocera-mesa-vulkan/releases/latest/download/mesa-vulkan-stack.tar.gz}"
STACK_TAR="mesa-vulkan-stack.tar.gz"

# ============================================================
log() {
  echo "[mesa-vulkan] $*"
}

# ============================================================
# Detect board (RPi4 vs RPi5)
# ============================================================
detect_board() {
  model=""

  if [ -r /proc/device-tree/model ]; then
    model=$(tr -d '\0' </proc/device-tree/model 2>/dev/null || true)
  else
    model=$(grep -i '^model' /proc/cpuinfo 2>/dev/null || true)
  fi

  case "$model" in
    *"Raspberry Pi 5"*)
      echo "rpi5"
      ;;
    *"Raspberry Pi 4"*)
      echo "rpi4"
      ;;
    *)
      log "WARNING: Could not detect board from model string:"
      log "         \"$model\""
      log "Falling back to RPi5 (cortex-a76)."
      echo "rpi5"
      ;;
  esac
}

# ============================================================
# Download stack
# ============================================================
download_stack() {
  log "Downloading stack:"
  log "  $STACK_URL"

  mkdir -p "${INSTALL_ROOT}"
  cd "${INSTALL_ROOT}"

  curl -fL -o "${STACK_TAR}.tmp" "${STACK_URL}"
  mv "${STACK_TAR}.tmp" "${STACK_TAR}"
}

# ============================================================
# Extract stack
# ============================================================
extract_stack() {
  cd "${INSTALL_ROOT}"

  # Fjern eventuell gammel katalog
  rm -rf "${INSTALL_DIR}"

  # Tarball har toppkatalog mesa-vulkan-25.3.0-1.4.328.1/
  tar xzf "${STACK_TAR}" -C "${INSTALL_ROOT}"

  log "Extracted to: ${INSTALL_DIR}"
}

# ============================================================
# Board-specific configuration
# ============================================================
configure_board_stack() {
  board="$1"

  log "Configuring for board: ${board}"

  rm -f "${INSTALL_DIR}/lib/libvulkan_broadcom.so" \
        "${INSTALL_DIR}/icd/broadcom_icd.json"

  case "$board" in
    rpi4)
      cp "${INSTALL_DIR}/lib/rpi4/libvulkan_broadcom.so" \
         "${INSTALL_DIR}/lib/libvulkan_broadcom.so"
      cp "${INSTALL_DIR}/icd/broadcom_icd.cortex-a72.json" \
         "${INSTALL_DIR}/icd/broadcom_icd.json"
      ;;
    rpi5)
      cp "${INSTALL_DIR}/lib/rpi5/libvulkan_broadcom.so" \
         "${INSTALL_DIR}/lib/libvulkan_broadcom.so"
      cp "${INSTALL_DIR}/icd/broadcom_icd.cortex-a76.json" \
         "${INSTALL_DIR}/icd/broadcom_icd.json"
      ;;
    *)
      log "Unknown board!"
      exit 1
      ;;
  esac
}

# ============================================================
# Update /userdata/system/.profile
# ============================================================
configure_profile() {
  profile="${INSTALL_ROOT}/.profile"
  log "Updating ${profile}"

  # Fjern gammel blokk hvis den finnes
  sed -i '/# MESA_VULKAN_STACK BEGIN/,/# MESA_VULKAN_STACK END/d' "${profile}" 2>/dev/null || true

  cat >> "${profile}" <<EOF

# MESA_VULKAN_STACK BEGIN
export MESA_STACK_DIR="${INSTALL_DIR}"
export LD_LIBRARY_PATH="\${MESA_STACK_DIR}/lib:\${LD_LIBRARY_PATH}"
export VK_ICD_FILENAMES="\${MESA_STACK_DIR}/icd/broadcom_icd.json"
# MESA_VULKAN_STACK END
EOF
}

# ============================================================
# Main
# ============================================================
main() {
  board=$(detect_board)

  log "Detected board: ${board}"

  download_stack
  extract_stack
  configure_board_stack "${board}"
  configure_profile

  log "Installation complete. Reboot Batocera to apply."
}

main "$@"

