#!/bin/env bash
set -euxo pipefail

# renovate: datasource=docker depName=alpine extractVersion=^(?<version>[0-9]+(\.[0-9]+)+)$
alpine_version='3.22.1'

# ref https://github.com/firecracker-microvm/firecracker/blob/main/docs/rootfs-and-kernel-setup.md

umount /tmp/firecracker-vm-alpine-rootfs 2>/dev/null || true
if [ -e /tmp/firecracker-vm-alpine-rootfs ]; then
    rmdir /tmp/firecracker-vm-alpine-rootfs
fi

output_file=/tmp/firecracker-vm-alpine-rootfs-$alpine_version.ext4
rm -f $output_file
install -m 700 -d /tmp/firecracker-vm-alpine-rootfs
install -m 600 /dev/null $output_file
truncate --size 128M $output_file
mkfs.ext4 -F $output_file
mount $output_file /tmp/firecracker-vm-alpine-rootfs
docker run -i --rm -v /tmp/firecracker-vm-alpine-rootfs:/rootfs "alpine:$alpine_version" <<'EOF'
set -euxo pipefail

# set the root password.
echo 'root:root' | chpasswd

# disable the virtual login terminals.
sed -i -E 's/^(tty\d+:.+)/#\1/g' /etc/inittab

# enable the serial port login terminal.
sed -i -E 's/^#(ttyS0:.+)/\1/g' /etc/inittab

# install the required packages.
apk add openrc
apk add util-linux

# on boot, mount the required filesystems.
rc-update add devfs boot
rc-update add procfs boot
rc-update add sysfs boot

# install into rootfs.
for d in bin etc lib root sbin usr; do
    tar c "/$d" | tar x -C /rootfs
done
for d in dev proc run sys var; do
    install -d "/rootfs/$d"
done
EOF
umount /tmp/firecracker-vm-alpine-rootfs
rmdir /tmp/firecracker-vm-alpine-rootfs
# dumpe2fs $output_file
