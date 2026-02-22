#!/bin/bash
cd `dirname $0`
source shared-qemu.sh

# Ensure we use an absolute path for the destination to avoid "O=" path confusion
DEST_CONFIG=$(readlink -f "${AESD_MODIFIED_DEFCONFIG}")

mkdir -p base_external/configs/

# 1. Save the Buildroot defconfig
# We use the absolute path to the out_qemu directory
make -C buildroot O=out_qemu savedefconfig BR2_DEFCONFIG="${DEST_CONFIG}"

# 2. Save the Linux defconfig if it exists
# Note: In 'O=out_qemu', there is NO 'output' folder level.
# It is buildroot/out_qemu/build/...
LINUX_CONFIG=$(ls buildroot/out_qemu/build/linux-*/.config 2>/dev/null | head -n 1)

if [ -f "$LINUX_CONFIG" ]; then
    if grep -q "BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE" buildroot/out_qemu/.config; then
        echo "Saving linux defconfig..."
        make -C buildroot O=out_qemu linux-update-defconfig
    fi
fi
