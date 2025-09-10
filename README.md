# firecracker-tools

Just some notes I got when tinkering with firecracker.

## create_rootfs.sh

```sh
sudo ./create_rootfs.sh
```

Requires docker.

You should have `firecracker-vm-alpine-rootfs-<version>.ext4` in `/tmp` after this.

## build kernel

...

## create your first microvm

I use [firectl](https://github.com/firecracker-microvm/firectl)

Download the kernel & rootfs. Or use one you build above

```sh
curl -fsSL -o hello-vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/hello/kernel/hello-vmlinux.bin
curl -fsSL -o hello-rootfs.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/hello/fsfiles/hello-rootfs.ext4
```

```sh
go build

./firectl \
  --kernel=hello-vmlinux.bin \
  --root-drive=hello-rootfs.ext4
```

You should see sth like this. The version of Alpine should match if you build the rootfs yourself like above.

```
Welcome to Alpine Linux 3.22
Kernel 4.14.55-84.37.amzn2.x86_64 on x86_64 (/dev/ttyS0)

(none) login: root
Password:
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.
```
