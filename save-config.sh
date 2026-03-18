#!/bin/bash
#Modified to use BBB config instead of qemu
#Author: Kevin Diaz
#
#Original Desc: Script to save the modified configuration as modified_qemu_aarch64_virt_defconfig and linux kernel configuration.
#Original Author: Siddhant Jajoo.

cd `dirname $0`
source shared.sh
mkdir -p base_external/configs/
make -C buildroot savedefconfig BR2_DEFCONFIG=${AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT}
make -C buildroot swupdate-update-config

if [ -e buildroot/.config ] && [ ls buildroot/output/build/linux-*/.config 1> /dev/null 2>&1 ]; then
        grep "BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE" buildroot/.config > /dev/null
        if [ $? -eq 0 ]; then
                echo "Saving linux defconfig"
                make -C buildroot linux-update-defconfig
        fi
fi
