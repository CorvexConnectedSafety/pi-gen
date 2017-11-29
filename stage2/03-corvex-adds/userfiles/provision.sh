#!/bin/bash
#
# usage: provision.sh subID locID

initarget=/var/www/html/scripts/localconfig.ini
inisrc=/home/corvex/localconfig.tmpl
configtarget=/var/www/html/scripts/tools/config.sh
configsrc=/home/corvex/config.tmpl

subID=$1
locID=$2

if [ -z "$subID" -o -z "$locID" ]
then
    echo "Usage: provision.sh subscriberID locationID"
    exit 1
fi

sed -e "s/SUBSCRIBERID/$subID/" -e "s/LOCATIONID/$locID/" < $inisrc > $initarget
sed -e "s/SUBSCRIBERID/$subID/" -e "s/LOCATIONID/$locID/" < $configsrc > $configtarget

chmod +x $configtarget

echo "Configuration updated"
