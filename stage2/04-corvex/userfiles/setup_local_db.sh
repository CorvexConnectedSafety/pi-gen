#!/bin/sh

if [! -f /var/lib/mysql/ibdata1 ]
then
	mysql_install_db

	systemctl enable mysql
	service mysql start

    sleep 5
	mysql -u root mysql << HERE
DROP USER IF EXISTS 'beaconadmin'@'%';
DROP USER IF EXISTS 'beaconadmin'@'localhost';
CREATE USER 'beaconadmin'@'%' IDENTIFIED BY 'ppeRocks!';
CREATE USER 'beaconadmin'@'localhost' IDENTIFIED BY 'ppeRocks!';
GRANT ALL PRIVILEGES ON *.* to 'beaconadmin'@'%';
GRANT ALL PRIVILEGES ON *.* to 'beaconadmin'@'localhost';
FLUSH PRIVILEGES;
HERE

fi

mysql -u beaconadmin -p'ppeRocks!' < sqldata/beacons.sql
mysql -u beaconadmin -p'ppeRocks!' < sqldata/baseline.sql
