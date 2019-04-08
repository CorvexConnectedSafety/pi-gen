#!/bin/bash -e

# enable US
sed ${ROOTFS_DIR}/etc/locale.gen -i -e "s|# en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|"
# sed ${ROOTFS_DIR}/etc/locale.gen -i -e "s|en_GB.UTF-8 UTF-8|# en_US.UTF-8 UTF-8|"
sed ${ROOTFS_DIR}/etc/default/keyboard -i -e "s|gb|us|"
sed ${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf -i -e "s|workstation=no|workstation=yes|"
sed ${ROOTFS_DIR}/etc/hosts -i -e "s|raspberrypi|CorvexGW01|"
sed ${ROOTFS_DIR}/etc/hostname -i -e "s|raspberrypi|CorvexGW01|"

install -m 755 files/60-corvex.conf ${ROOTFS_DIR}/etc/sysctl.d/
install -m 755 files/corvex ${ROOTFS_DIR}/etc/init.d/
install -m 755 files/corvex.service ${ROOTFS_DIR}/etc/avahi/services
install -m 755 files/crontab ${ROOTFS_DIR}/etc/cron.d/corvex
install -m 440 files/sudo ${ROOTFS_DIR}/etc/sudoers.d/020_corvex-nopasswd

on_chroot << EOF
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8
if ! id -u corvex >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" corvex
fi
echo "corvex:"$GW_PASS | chpasswd
echo "pi:"$GW_PASS | chpasswd
adduser corvex sudo
EOF

install -m 600 userfiles/tunnel_key ${ROOTFS_DIR}/home/corvex
install -m 600 userfiles/tunnel_key.pub ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/localconfig.tmpl ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/config.tmpl ${ROOTFS_DIR}/home/corvex

install -m 755 userfiles/unifi-setup.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/provision.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/tunnel.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/90proxy ${ROOTFS_DIR}/home/corvex

install -m 644 files/nodesource.list ${ROOTFS_DIR}/etc/apt/sources.list.d/
install -m 644 files/interfaces ${ROOTFS_DIR}/etc/network/interfaces.d/

on_chroot apt-key add - < files/nodesource.gpg.key
on_chroot << EOF2
if ! -x /usr/bin/docker; then
    curl -sSL https://get.docker.com | sh
fi
EOF2


