#!/bin/sh
set -e

INSTALL_ROOT="/userdata/system"
STACK_DIR_NAME="mesa-vulkan-25.3.0-1.4.328.1"
INSTALL_DIR="${INSTALL_ROOT}/${STACK_DIR_NAME}"

echo "== LIB CONTENT =="
ls -lh "${INSTALL_DIR}/lib" || {
  echo "!! Could not list ${INSTALL_DIR}/lib – is the stack installed?"
  exit 1
}

echo
echo "== ICD FILE =="
cat "${INSTALL_DIR}/icd/broadcom_icd.json" || {
  echo "!! Could not read ICD file"
}

echo
echo "== CHECK Mesa/V3DV driver =="
if [ -f "${INSTALL_DIR}/lib/libvulkan_broadcom.so" ]; then
  strings "${INSTALL_DIR}/lib/libvulkan_broadcom.so" | grep -E 'Mesa|V3DV' | head || true
else
  echo "!! libvulkan_broadcom.so not found"
fi

echo
echo "== CHECK Vulkan loader =="
if ls "${INSTALL_DIR}/lib/libvulkan.so.1.4.328"* >/dev/null 2>&1; then
  strings "${INSTALL_DIR}/lib/libvulkan.so.1.4.328"* | grep -i "Vulkan" | head || true
else
  echo "!! libvulkan.so.1.4.328* not found"
fi

