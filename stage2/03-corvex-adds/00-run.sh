#!/bin/bash -e

on_chroot << EOF
locale-gen en_US.UTF-8
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"
if ! id -u corvex >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" corvex
fi
echo "corvex:"$GW_PASS | chpasswd
adduser corvex sudo
update-rc.d ssh enable
EOF
sed ${ROOTFS_DIR}/etc/default/keyboard -i -e "s|gb|us|"
sed ${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf -i -e "s|workstation=no|workstation=yes|"
sed ${ROOTFS_DIR}/etc/hosts -i -e "s|raspberrypi|CorvexGW01|"
sed ${ROOTFS_DIR}/etc/hostname -i -e "s|raspberrypi|CorvexGW01|"

cat >> ${ROOTFS_DIR}/etc/network/interfaces << CONFIG
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
CONFIG

install -m 600 userfiles/tunnel_key ${ROOTFS_DIR}/home/corvex
install -m 600 userfiles/tunnel_key.pub ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/localconfig.tmpl ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/config.tmpl ${ROOTFS_DIR}/home/corvex

install -m 755 userfiles/provision.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/tunnel.sh ${ROOTFS_DIR}/home/corvex

install -m 644 files/nodesource.list ${ROOTFS_DIR}/etc/apt/sources.list.d/

on_chroot apt-key add - < files/nodesource.gpg.key
on_chroot << EOF2
apt-get update
EOF2

