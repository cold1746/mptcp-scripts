#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# Create and update the debian-repos
file=`basename $0` 
trap "mutt -s \"$file crontab-failure\" -- christoph.paasch@uclouvain.be < /tmp/${file}.log; exit 1" ERR

kernel_version="3.0.9.mptcp+"

# Update sources 
cd /usr/src/mtcp/
git pull

# Compile everything
make 
make install modules_install
# Install new kernel on host-machine

if [ -f /boot/initrd.img-${kernel_version} ]
then
	/usr/sbin/update-initramfs -u -k $kernel_version
else
	/usr/sbin/update-initramfs -c -k $kernel_version
fi

# Reboot

/usr/bin/touch /root/rebooted
/sbin/reboot
