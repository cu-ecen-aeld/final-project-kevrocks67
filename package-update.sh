#!/bin/bash
set -euo pipefail

KEY_PATH="${SWUPDATE_KEY_PATH:-$HOME/aesd-priv.pem}"
BUILDROOT_IMAGES="buildroot/output/images"
UPDATE_DIR="updates"
PRODUCT_NAME="door_security_os"

# Get the unique version string created by post-build.sh
if [ -f "buildroot/output/target/etc/os-version" ]; then
    VERSION=$(cat buildroot/output/target/etc/os-version)
else
    VERSION="1.0-manual-$(date +%Y%m%d)"
fi

echo "--- Packaging $PRODUCT_NAME Version: $VERSION ---"

echo "Compressing RootFS..."
gzip -c "${BUILDROOT_IMAGES}/rootfs.ext4" > "${UPDATE_DIR}/rootfs.ext4.gz"

echo "Retrieving Kernel and Device Tree..."
cp "${BUILDROOT_IMAGES}/zImage" "${UPDATE_DIR}/"
cp "${BUILDROOT_IMAGES}/am335x-boneblack.dtb" "${UPDATE_DIR}/"

echo "Calculating SHA256 Hash..."
ROOTFS_HASH=$(sha256sum "${UPDATE_DIR}/rootfs.ext4.gz" | awk '{print $1}')
KERNEL_HASH=$(sha256sum "${UPDATE_DIR}/zImage" | awk '{print $1}')
DTB_HASH=$(sha256sum "${UPDATE_DIR}/am335x-boneblack.dtb" | awk '{print $1}')

echo "Generating sw-description from template..."

cp "${UPDATE_DIR}/sw-description.tmpl" "${UPDATE_DIR}/sw-description"
sed -i "s/VERSION_HERE/$VERSION/" "${UPDATE_DIR}/sw-description"
sed -i "s/ROOTFS_HASH_HERE/$ROOTFS_HASH/" "${UPDATE_DIR}/sw-description"
sed -i "s/KERNEL_HASH_HERE/$KERNEL_HASH/" "${UPDATE_DIR}/sw-description"
sed -i "s/DTB_HASH_HERE/$DTB_HASH/" "${UPDATE_DIR}/sw-description"

# Sign SWU
if [ ! -f "$KEY_PATH" ]; then
    echo "ERROR: Private key not found at $KEY_PATH. Skipping signing!"
    exit 1
fi

echo "Signing with: $KEY_PATH"
openssl dgst -sha256 -sign "$KEY_PATH" -out "${UPDATE_DIR}/sw-description.sig" "${UPDATE_DIR}/sw-description"

# Create SWU
FILES="sw-description sw-description.sig rootfs.ext4.gz zImage am335x-boneblack.dtb"

echo "Creating .swu archive..."
cd "${UPDATE_DIR}"
for i in $FILES; do
    if [ ! -f "$i" ]; then
        echo "ERROR: Missing $i"
        exit 1
    fi
    echo "$i"
done | cpio -ov -H crc > "../${PRODUCT_NAME}_latest.swu"

echo "--- SUCCESS: Generated ${PRODUCT_NAME}_latest.swu ---"
