#!/bin/bash
#
# start_service.sh - start up a corvex REST docker instance


CORVEXCONTAINER=rest-api
CORVEXDIR=/var/www/html
CORVEX_SUBSCRIBER=01
CORVEXIMAGE=registry.gitlab.com/corvexconnected/rest-api:arm-latest

CORVEXPORT=120${CORVEX_SUBSCRIBER}

docker network create corvex

if [ ! -f localconfig.ini ]
then
        echo "You must have a localconfig.ini file."
        exit 1;
fi

service memcached restart

# start
if [ ! "$(docker ps -q -f name=${CORVEXCONTAINER})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${CORVEXCONTAINER})" ]; then
        # cleanup
        docker rm ${CORVEXCONTAINER}
    fi
    # ensure there is a logs directory

    # run your container
    docker run -d -it --network corvex --restart always --name ${CORVEXCONTAINER} --log-opt max-size=10m --log-opt max-file=5 -p 80:80 -v ${CORVEXDIR}/objects:/usr/local/apache2/htdocs/objects -v ${CORVEXDIR}/uploads:/usr/local/apache2/htdocs/uploads -v ${CORVEXDIR}/static:/usr/local/apache2/htdocs/static ${CORVEXIMAGE}
fi

sleep 2

echo "updating configuration";
docker cp localconfig.ini ${CORVEXCONTAINER}:/usr/local/apache2/htdocs/scripts/localconfig.ini
docker cp /var/www/html/scripts/tools/config.sh ${CORVEXCONTAINER}:/usr/local/apache2/htdocs/scripts/tools/config.sh
docker cp tunnel_key ${CORVEXCONTAINER}:/home/corvex/tunnel_key
docker cp tunnel_key.pub ${CORVEXCONTAINER}:/home/corvex/tunnel_key.pub
docker exec -u www-data ${CORVEXCONTAINER} mkdir -p /var/www/html
docker exec -u www-data ${CORVEXCONTAINER} ln -s /usr/local/apache2/htdocs/scripts /var/www/html/scripts
docker exec -u www-data ${CORVEXCONTAINER} ln -s /usr/local/apache2/htdocs/objects /var/www/html/objects
docker exec -u www-data ${CORVEXCONTAINER} ln -s /usr/local/apache2/htdocs/uploads /var/www/html/uploads

echo "Started up container ${CORVEXCONTAINER}. Following log."
echo ""
docker logs -f ${CORVEXCONTAINER}
