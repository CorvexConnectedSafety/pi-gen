#!/bin/bash -e

on_chroot << EOF
a2enmod rewrite
EOF

install -m 644 files/dnsmasq.conf ${ROOTFS_DIR}/etc
install -m 644 files/hostapd.conf ${ROOTFS_DIR}/etc/hostapd
install -m 644 files/000-default.conf ${ROOTFS_DIR}/etc/apache2/sites-enabled
cp -r ${GW_SCRIPTS} /var/www/html/scripts

