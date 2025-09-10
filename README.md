# firecracker-tools

Just some notes I got when tinkering with firecracker.

## create_rootfs.sh

```sh
sudo ./create_rootfs.sh
```

Requires docker.

You should have `firecracker-vm-alpine-rootfs.ext4` in `/tmp` after this.

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