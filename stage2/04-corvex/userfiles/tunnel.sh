#!/bin/sh

# check the connection very often
export AUTOSSH_POLL=30
if [ -f /var/www/html/scripts/tools/config.sh ]
then
    . /var/www/html/scripts/tools/config.sh
    dport=`printf '11%03d' "$subscriber"`
    dport=`printf '12%03d' "$subscriber"`
    echo "Remote tunnel on port $dport"
    autossh -f -N -p $port -o "ExitOnForwardFailure yes" -o "StrictHostKeyChecking no" -i /home/corvex/tunnel_key -L 10037:localhost:37 -L 172.18.0.1:13306:$dbServer:13306 -L 5667:$monitoring:5667 -L 172.18.0.1:10443:loki-ingest.svc.corvexconnected.com:443 -L 3128:127.0.0.1:3128 -L 172.18.0.1:8088:127.0.0.1:$sport $tunnelUser@$tunnelServer 2>&1
    autossh -f -N -p $port -o "ExitOnForwardFailure yes" -o "StrictHostKeyChecking no" -i /home/corvex/tunnel_key -R $dport:127.0.0.1:22 $tunnelUser@$tunnelServer 2>&1
fi

