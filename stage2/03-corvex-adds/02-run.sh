#!/bin/bash -e

install -m 644 files/dnsmasq.conf ${ROOTFS_DIR}/etc
install -m 644 files/hostapd.conf ${ROOTFS_DIR}/etc/hostapd
install -m 644 files/000-default.conf ${ROOTFS_DIR}/etc/apache2/sites-enabled
mkdir -p ${ROOTFS_DIR}/var/www/html/uploads
mkdir -p ${ROOTFS_DIR}/var/www/html/objects
mkdir -p ${ROOTFS_DIR}/var/www/html/scripts
cp -r ${GW_SCRIPTS}/* ${ROOTFS_DIR}/var/www/html/scripts

on_chroot << EOF
timedatectl set-timezone "America/Chicago"
update-rc.d ssh enable
update-rc.d corvex defaults
update-rc.d corvex enable
update-rc.d rpimonitord enable
a2enmod rewrite
a2enmod cgi
a2dismod mpm_event
a2enmod mpm_prefork
cpanm -n JSON::DWIW
cpanm -n Net::Address::IPv4::Local
EOF

sed ${ROOTFS_DIR}/etc/apache2/mods-enabled/mpm_prefork.conf  -i -e "s|MaxRequestWorkers.*|MaxRequestWorkers  50|"
sed ${ROOTFS_DIR}/etc/apache2/mods-enabled/mpm_prefork.conf  -i -e "s|MaxConnectionsPerChild.*|MaxConnectionsPerChild  100|"

# set up to use a proxy
install -m 644 files/90proxy ${ROOTFS_DIR}/etc/apt/apt.conf.d
