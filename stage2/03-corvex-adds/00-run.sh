#!/bin/bash -e

on_chroot << EOF
locale-gen en_US.UTF-8
update-locale LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"
if ! id -u corvex >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" corvex
fi
echo "corvex:"$GW_PASS | chpasswd
adduser corvex sudo
EOF
install -m 644 userfiles/tunnel_key ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/tunnel_key.pub ${ROOTFS_DIR}/home/corvex

install -m 644 files/nodesource.list ${ROOTFS_DIR}/etc/apt/sources.list.d/

on_chroot apt-key add - < files/nodesource.gpg.key
on_chroot << EOF2
apt-get update
EOF2

