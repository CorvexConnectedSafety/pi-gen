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
cp -r ${GW_WEB}/* ${ROOTFS_DIR}/var/www/html
cp -r ${GW_NAGIOS}/* ${ROOTFS_DIR}/usr/lib/nagios/plugins
sed ${ROOTFS_DIR}/etc/ssh/sshd_config  -i -e 's|#PasswordAuthentication .*$|PasswordAuthentication no|'

on_chroot << EOF
update-rc.d bluetooth disable
update-rc.d triggerhappy disable
update-rc.d corvex defaults
update-rc.d corvex enable
update-rc.d ntp enable
mkdir -p /var/log/corvex
chown www-data:www-data /var/log/corvex
rm -rf /var/www/html/scripts/logs
ln -s /var/log/corvex /var/www/html/scripts/logs
chown www-data:www-data /var/www/html/uploads
chown www-data:www-data /var/www/html/objects
docker login -u ${REGISTRY_USER} -p ${REGISTRY_PASS} ${REGISTRY}
EOF