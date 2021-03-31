#!/bin/sh

CPIO_FILENAME=alpine.cpio.gz

if [ $(whoami) != "root" ] ;then
	echo "ERROR: Please run script with sudo"
	exit 1
fi

if [ ! -e /usr/bin/qemu-arm-static ]; then
	echo "qemu-arm-static is not installed yet."
	exit 1
fi

./alpine-chroot-install -d rootfs -a armhf

cp -r resources rootfs
chroot rootfs sh -c "/resources/fixup"
rm -rf rootfs/resources

./rootfs/destroy
cd rootfs; find . | cpio -o -H newc 2> /dev/null | gzip > ../$CPIO_FILENAME; cd ..
./rootfs/destroy --remove
