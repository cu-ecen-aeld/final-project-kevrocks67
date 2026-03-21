setenv kernel_addr_r 0x82000000
setenv fdt_addr_r 0x88000000

if test "${ustate}" = "1"; then
    echo "Selecting slot B"
    setenv bootpartition mmcblk0p3
else
    echo "Selecting slot A"
    setenv bootpartition mmcblk0p2
fi

setenv bootargs console=ttyS0,115200n8 root=/dev/${bootpartition} rw rootfstype=ext4 rootwait

load mmc 0:1 ${kernel_addr_r} /zImage
load mmc 0:1 ${fdt_addr_r} /am335x-boneblack.dtb

printenv bootargs
bootz ${kernel_addr_r} - ${fdt_addr_r}
