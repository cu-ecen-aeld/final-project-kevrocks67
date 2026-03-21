#!/bin/sh

# $1 is the path to the target root filesystem, passed by Buildroot
TARGET_DIR=$1
VERSION_FILE="${TARGET_DIR}/etc/os-version"

EXTERNAL_BOARD_DIR="${BR2_EXTERNAL_project_base_PATH}/board/beagleboard/beaglebone"

install -m 0644 -D "${EXTERNAL_BOARD_DIR}/u-boot-initial-env" \
    "${TARGET_DIR}/etc/u-boot-initial-env"

cp "${BINARIES_DIR}/uboot-env.bin" "${BINARIES_DIR}/uboot.env"

echo "--- Starting AESD Post-Build Version Stamping ---"

GIT_HASH=$(git -C "${BR2_EXTERNAL_project_base_PATH}" rev-parse --short HEAD 2>/dev/null || echo "no-git")
BUILD_DATE=$(date +%Y%m%d-%H%M)
FULL_VERSION="v1.0-${GIT_HASH}-${BUILD_DATE}"

echo "Targeting: ${VERSION_FILE}"
echo "Stamping Version: ${FULL_VERSION}"
echo "${FULL_VERSION}" > "${VERSION_FILE}"

echo "--- Post-Build Stamping Complete ---"
