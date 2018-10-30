#!/bin/bash -e

install -m 644 files/dnsmasq.conf ${ROOTFS_DIR}/etc
install -m 644 files/hostapd.conf ${ROOTFS_DIR}/etc/hostapd
install -m 644 files/000-default.conf ${ROOTFS_DIR}/etc/apache2/sites-enabled
install -m 644 files/corvex.logrotate ${ROOTFS_DIR}/etc/logrotate.d/corvex
mkdir -p ${ROOTFS_DIR}/var/www/html/uploads
mkdir -p ${ROOTFS_DIR}/var/www/html/objects
mkdir -p ${ROOTFS_DIR}/var/www/html/scripts
cp -r ${GW_SCRIPTS}/* ${ROOTFS_DIR}/var/www/html/scripts
cp files/htaccess ${ROOTFS_DIR}/var/www/html/scripts/.htaccess

on_chroot << EOF
timedatectl set-timezone "America/Chicago"
update-rc.d ssh enable
update-rc.d corvex defaults
update-rc.d corvex enable
update-rc.d rpimonitord enable
update-rc.d mysql disable
update-rc.d ntp enable
update-rc.d docker disable
a2enmod rewrite
a2enmod cgi
a2dismod mpm_event
a2enmod mpm_prefork
cpanm -n JSON::DWIW
cpanm -n Net::Address::IPv4::Local
mkdir /var/www/html/scripts/logs
chown www-data:www-data /var/www/html/scripts/logs
chown www-data:www-data /var/www/html/uploads
chown www-data:www-data /var/www/html/objects
EOF

sed ${ROOTFS_DIR}/etc/apache2/mods-enabled/mpm_prefork.conf  -i -e "s|MaxRequestWorkers.*|MaxRequestWorkers  50|"
sed ${ROOTFS_DIR}/etc/apache2/mods-enabled/mpm_prefork.conf  -i -e "s|MaxConnectionsPerChild.*|MaxConnectionsPerChild  100|"
