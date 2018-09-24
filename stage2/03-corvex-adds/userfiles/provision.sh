#!/bin/bash
#
# usage: provision.sh subID locID

initarget=/var/www/html/scripts/localconfig.ini
inisrc=/home/corvex/localconfig.tmpl
configtarget=/var/www/html/scripts/tools/config.sh
configsrc=/home/corvex/config.tmpl

subID=$1
locID=$2
gwName=$3
beHost=$4
feHost=$5
fePath=$6

if [ -z "$subID" -o -z "$locID" ]
then
    echo "Usage: provision.sh subscriberID locationID gatewayName backendHost frontendHost frontendPath"
    exit 1
fi

sed -e "s/SUBSCRIBERID/$subID/" -e "s/LOCATIONID/$locID/"  -e "s/GATEWAYNAME/$gwName/" < $inisrc > $initarget
sed -e "s/SUBSCRIBERID/$subID/" -e "s/LOCATIONID/$locID/" -e "s/GATEWAYNAME/$gwName/" -e "s/BACKENDHOST/$beHost/" -e "s/FRONTENDHOST/$feHost/" -e "s/FRONTENDPATH/$fePath/" < $configsrc > $configtarget

chmod +x $configtarget

echo "Configuration updated"
