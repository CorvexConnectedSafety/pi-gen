#!/bin/bash -e

install -m 644 files/dnsmasq.conf ${ROOTFS_DIR}/etc
install -m 644 files/hostapd.conf ${ROOTFS_DIR}/etc/hostapd
install -m 644 files/000-default.conf ${ROOTFS_DIR}/etc/apache2/sites-enabled
mkdir -p ${ROOTFS_DIR}/var/www/html/uploads
mkdir -p ${ROOTFS_DIR}/var/www/html/objects
mkdir -p ${ROOTFS_DIR}/var/www/html/scripts
mkdir -p ${ROOTFS_DIR}/var/www/html/static
mkdir -p ${ROOTFS_DIR}/var/www/html/corvex
cp -r ${GW_NAGIOS}/* ${ROOTFS_DIR}/usr/lib/nagios/plugins

sed ${ROOTFS_DIR}/etc/ssh/sshd_config  -i -e 's|#PasswordAuthentication .*$|PasswordAuthentication no|'

on_chroot << EOF
update-rc.d bluetooth disable
update-rc.d hostapd disable
update-rc.d triggerhappy disable
update-rc.d mysql disable
update-rc.d corvex defaults
update-rc.d corvex enable
update-rc.d ntp enable
chown www-data:www-data /home/corvex/tunnel_key*
chown corvex:corvex /home/corvex/.ssh/authorized_keys
chown www-data:www-data /var/www/html/uploads
chown www-data:www-data /var/www/html/objects
EOF

if [ -z "${CCS_CONTAINERS}" ]
then
install -m 644 files/corvex.logrotate ${ROOTFS_DIR}/etc/logrotate.d/corvex
cp -r ${GW_SCRIPTS}/* ${ROOTFS_DIR}/var/www/html/scripts
cp files/htaccess ${ROOTFS_DIR}/var/www/html/scripts/.htaccess
cp files/object_htaccess ${ROOTFS_DIR}/var/www/html/objects/.htaccess
cp -r ${GW_WEB}/* ${ROOTFS_DIR}/var/www/html/corvex/
sed ${ROOTFS_DIR}/etc/apache2/apache2.conf  -i -e "s|^KeepAlive..*|KeepAlive Off|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|StartServers\t.*|StartServers\t\t  5|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MinSpareServers\t.*|MinSpareServers\t\t  5|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MaxSpareServers\t.*|MaxSpareServers\t\t  10|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|MaxRequestWorkers\t.*|MaxRequestWorkers\t\t  50|"
sed ${ROOTFS_DIR}/etc/apache2/mods-available/mpm_prefork.conf  -i -e "s|\tMaxConnectionsPerChild.*|\tMaxConnectionsPerChild 100|"
on_chroot << NEOF
a2dismod mpm_event
a2dismod mpm_prefork
a2enmod mpm_prefork
a2enmod rewrite
a2enmod deflate
a2enmod cgi
a2enmod headers
cpanm -f -n File::Find::Rule
cpanm -f -n List::Compare
cpanm -f -n Proc::Simple
cpanm -n Cache::Memcached::Fast
cpanm -n Config::Tiny
cpanm -n DateTime DateTime::Duration
cpanm -n Devel::CheckLib
cpanm -n Email::Stuffer
cpanm -n File::Find::Rule
cpanm -n File::MimeInfo::Magic;
cpanm -n File::Temp;
cpanm -n Hash::Merge
cpanm -n JSON::DWIW
cpanm -n List::Compare
cpanm -n List::MoreUtils
cpanm -n List::Util
cpanm -n Log::Log4perl
cpanm -n Net::Address::IPv4::Local
cpanm -n Net::Curl
cpanm -n Path::Tiny
cpanm -n Pod::Coverage
cpanm -n Pod::Usage
cpanm -n Proc::Simple
cpanm -n SMS::Send::Twilio
cpanm -n TAP::Parser
cpanm -n Test::More
cpanm -n Test::WWW::Mechanize
cpanm -n Test::WWW::Mechanize::JSON
cpanm -n Time::HiRes
cpanm -n Try::Tiny
cpanm -n XML::Generator

mkdir -p /var/log/corvex
chown www-data:www-data /var/log/corvex
rm -rf /var/www/html/scripts/logs
ln -s /var/log/corvex /var/www/html/scripts/logs
NEOF
else
    on_chroot << CEOF
systemctl disable apache2
CEOF
fi

# if [ ! -f /usr/bin/docker ] ; then
    #curl --noproxy '*' --insecure -sSL https://get.docker.com | sh
#fi
#if [ ! -d /run/systemd ] ; then
#    mkdir -p /run/systemd ;
    #chmod 755 /run/systemd ;
    #curl --noproxy '*' -sfL https://get.k3s.io | sh - ;
#    systemctl disable k3s ;
#fi
# docker pull memcached:latest
# docker pull registry:2
#if [ ! -z "${REGISTRY}" ] ; then
    # docker login -u ${REG_USER} -p ${REG_PASS} ${REGISTRY}; 
    # docker pull registry.gitlab.com/corvexconnected/rest-api:arm-latest
#fi
#CEOF
# fi
