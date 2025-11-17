#!/bin/sh
#
# Mesa/Vulkan override self-update for Batocera v42
# Supports: Raspberry Pi 4 (bcm2711) & Raspberry Pi 5 (bcm2712)

set -e

REPO_OWNER="tbrautaset"
REPO_NAME="rpi-batocera-mesa-vulkan"
STACK_DIR_NAME="mesa-vulkan-25.3.0-1.4.328.1"
ASSET_TARBALL="mesa-vulkan-stack.tar.gz"
ASSET_SHA256="${ASSET_TARBALL}.sha256"

BASE_RELEASE_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/releases/latest/download"

WORKDIR="/userdata/system"
TMPDIR="${WORKDIR}/.mesa-vulkan-tmp"
STACK_DIR="${WORKDIR}/${STACK_DIR_NAME}"

echo "[mesa-vulkan] Self-update starting..."

# Soft sanity check: warn instead of abort if file is missing
if ! grep -q "Batocera.linux" /usr/lib/os-release 2>/dev/null; then
  echo "[mesa-vulkan] WARNING: This does not look like Batocera.linux."
  echo "[mesa-vulkan]          Continuing anyway."
fi

