#!/bin/bash
#Script to build buildroot configuration
#Author: Siddhant Jajoo
# Set variables based on target

EXTERNAL_REL_BUILDROOT=../base_external
git submodule init
git submodule sync
git submodule update

set -e
cd `dirname $0`

if [[ $1 == "qemu" ]]; then
    build_type="qemu"
    O_FLAG="O=out_qemu"
    CONFIG_PATH="out_qemu/.config"
    source shared-qemu.sh
else
    build_type="bbb"
    O_FLAG=""
    CONFIG_PATH=".config"
    source shared.sh
fi

# Check if the SPECIFIC folder is configured
if [ ! -e buildroot/${CONFIG_PATH} ]; then
    echo "CONFIGURING $build_type..."
    make -C buildroot ${O_FLAG} BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT} aesd_${build_type}_defconfig
fi

echo "BUILDING ${build_type}..."
make -C buildroot ${O_FLAG} BR2_EXTERNAL=${EXTERNAL_REL_BUILDROOT}
