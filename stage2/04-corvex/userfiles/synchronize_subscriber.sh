#!/bin/sh

DBSERVER=db1.corvexconnected.com
DBPORT=3306
SUBSCRIBER=$1

DB=beacons0000${SUBSCRIBER}

# rsync the images
echo "Synchronizing object collection"
rsync -av -e 'ssh -i /home/corvex/tunnel_key' ccs@db1.corvexconnected.com:/var/www/db1/objects/sub0000${SUBSCRIBER}/ /var/www/html/objects

# pull down the sql

echo "Dumping database at " `date`
mysqldump --host $DBSERVER --port $DBPORT -u beaconadmin -p'ppeRocks!' --databases beacons > b.sql
mysqldump --host $DBSERVER --port $DBPORT -u beaconadmin -p'ppeRocks!' --databases beacons0000${SUBSCRIBER} > b${SUBSCRIBER}.sql
echo "Dump complete at " `date`

# load it up

if [ -f b${SUBSCRIBER}.sql ]
then
	echo "Loading data - this may take a while";
	date
    mysql -u root < b.sql
	mysql -u root < b${SUBSCRIBER}.sql
	date
fi
