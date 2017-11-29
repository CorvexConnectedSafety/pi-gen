#!/bin/bash -e

install -m 644 files/dnsmasq.conf ${ROOTFS_DIR}/etc
install -m 644 files/hostapd.conf ${ROOTFS_DIR}/etc/hostapd
install -m 644 files/000-default.conf ${ROOTFS_DIR}/etc/apache2/sites-enabled
mkdir -p ${ROOTFS_DIR}/var/www/html/uploads
mkdir -p ${ROOTFS_DIR}/var/www/html/objects
mkdir -p ${ROOTFS_DIR}/var/www/html/scripts
cp -r ${GW_SCRIPTS}/* ${ROOTFS_DIR}/var/www/html/scripts

on_chroot << EOF
a2enmod rewrite
a2enmod cgi
cpanm JSON::DWIW
EOF

