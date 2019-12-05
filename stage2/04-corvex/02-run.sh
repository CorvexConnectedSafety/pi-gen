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
sed ${ROOTFS_DIR}/etc/apache2/apache2.conf  -i -e "s|^KeepAlive..*|KeepAlive Off|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|StartServers\t.*|StartServers\t\t  5|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MinSpareServers\t.*|MinSpareServers\t\t  5|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MaxSpareServers\t.*|MaxSpareServers\t\t  10|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MaxRequestWorkers\t.*|MaxRequestWorkers\t\t  50|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|\tMaxConnectionsPerChild.*|\tMaxConnectionsPerChild 100|"
sed ${ROOTFS_DIR}/etc/ssh/sshd_config  -i -e 's|#PasswordAuthentication .*$|PasswordAuthentication no|'

on_chroot << EOF
update-rc.d bluetooth disable
update-rc.d hostapd disable
update-rc.d triggerhappy disable
update-rc.d corvex defaults
update-rc.d corvex enable
update-rc.d ntp enable
a2dismod mpm_event
a2dismod mpm_prefork
a2enmod mpm_prefork
a2enmod rewrite
a2enmod deflate
a2enmod cgi
a2enmod headers
cpanm -n JSON::DWIW
cpanm -n Net::Address::IPv4::Local
cpanm -n DateTime DateTime::Duration
cpanm -f -n List::Compare
cpanm -f -n File::Find::Rule
cpanm -f -n Proc::Simple
mkdir -p /var/log/corvex
chown www-data:www-data /var/log/corvex
rm -rf /var/www/html/scripts/logs
ln -s /var/log/corvex /var/www/html/scripts/logs
chown www-data:www-data /var/www/html/uploads
chown www-data:www-data /var/www/html/objects
chown www-data:www-data /home/corvex/tunnel_key*
EOF

on_chroot << EOF2
chown corvex:corvex /home/corvex/.ssh/authorized_keys
curl --insecure -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
if [ ! -f /usr/bin/docker ] ; then
    curl --insecure -sSL https://get.docker.com | sh
fi
systemctl disable docker
systemctl disable containerd
curl -sfL https://get.k3s.io | sh -
systemctl disable k3s
EOF2

