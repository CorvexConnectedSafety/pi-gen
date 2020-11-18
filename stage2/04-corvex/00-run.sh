#!/bin/bash -e

# enable US
# sed ${ROOTFS_DIR}/etc/locale.gen -i -e "s|# en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|"
# sed ${ROOTFS_DIR}/etc/locale.gen -i -e "s|en_GB.UTF-8 UTF-8|# en_US.UTF-8 UTF-8|"
# sed ${ROOTFS_DIR}/etc/default/keyboard -i -e "s|gb|us|"
sed ${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf -i -e "s|workstation=no|workstation=yes|"
# sed ${ROOTFS_DIR}/etc/hosts -i -e "s|rpibuilder|CorvexGW01|"
# sed ${ROOTFS_DIR}/etc/hostname -i -e "s|rpibuilder|CorvexGW01|"

# enable i2c
sed ${ROOTFS_DIR}/boot/config.txt -i -e "s|#dtparam=i2c_arm=on|dtparam=i2c_arm=on|"

install -m 755 files/60-corvex.conf ${ROOTFS_DIR}/etc/sysctl.d/
install -m 755 files/corvex ${ROOTFS_DIR}/etc/init.d/
# install -m 755 files/corvex.service ${ROOTFS_DIR}/etc/avahi/services
# install -m 755 files/crontab ${ROOTFS_DIR}/etc/cron.d/corvex
install -m 440 files/sudo ${ROOTFS_DIR}/etc/sudoers.d/020_corvex-nopasswd

on_chroot << EOF
# locale-gen en_US.UTF-8
# update-locale LANG=en_US.UTF-8
rm -f /var/www/html/index.html
adduser corvex sudo
mkdir -p /home/corvex/.ssh
EOF

install -m 600 userfiles/gitlab_key ${ROOTFS_DIR}/home/corvex/.ssh
install -m 640 userfiles/gitlab_key.pub ${ROOTFS_DIR}/home/corvex/.ssh
install -m 600 userfiles/sshconfig ${ROOTFS_DIR}/home/corvex/.ssh
install -m 600 userfiles/authorized_keys ${ROOTFS_DIR}/home/corvex/.ssh

on_chroot << EOF
chown corvex:corvex -R /home/corvex/.ssh
chmod 700 /home/corvex/.ssh
EOF

install -m 600 userfiles/tunnel_key ${ROOTFS_DIR}/home/corvex
install -m 600 userfiles/tunnel_key.pub ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/localconfig.tmpl ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/config.tmpl ${ROOTFS_DIR}/home/corvex
install -m 644 userfiles/settings.tmpl ${ROOTFS_DIR}/home/corvex

install -m 755 userfiles/unifi-setup.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/fetch-containers.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/start_service.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/setup_local_db.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/start_webapp.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/synchronize_subscriber.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/provision.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/tunnel.sh ${ROOTFS_DIR}/home/corvex
install -m 755 userfiles/90proxy ${ROOTFS_DIR}/home/corvex
install -m 755 files/corvex.service ${ROOTFS_DIR}/home/corvex

install -m 644 files/interfaces ${ROOTFS_DIR}/etc/network/interfaces.d/
