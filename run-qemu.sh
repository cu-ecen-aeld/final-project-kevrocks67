#!/bin/bash
qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a53 \
    -nographic \
    -smp 1 \
    -m 256 \
    -kernel buildroot/out_qemu/images/Image \
    -append "root=/dev/vda console=ttyAMA0" \
    -drive file=buildroot/out_qemu/images/rootfs.ext4,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=net0 -device virtio-net-device,netdev=net0
