#!/bin/bash
#
# start_webapp.sh - start up a corvex webapp docker instance


CORVEXCONTAINER=webapp
CORVEXDIR=/var/www/html
CORVEXIMAGE=registry.gitlab.com/corvexconnected/webapp:arm-latest

if [ ! -f settings.json ]
then
	echo "Please create the settings.json file for this instance."
	exit 1;
fi


docker network create corvex

# start
if [ ! "$(docker ps -q -f name=${CORVEXCONTAINER})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${CORVEXCONTAINER})" ]; then
        # cleanup
        docker rm ${CORVEXCONTAINER}
    fi
    # ensure there is a logs directory

    # run your container
    docker run -d -it --network corvex --restart always --name ${CORVEXCONTAINER} --log-opt max-size=10m --log-opt max-file=5 -p 80:80 -v ${CORVEXDIR}/objects:/usr/local/apache2/htdocs/objects -v ${CORVEXDIR}/uploads:/usr/local/apache2/htdocs/uploads ${CORVEXIMAGE}
fi

sleep 2

echo "updating configuration";
docker cp settings.json ${CORVEXCONTAINER}:/usr/local/apache2/htdocs/assets/config/settings.json

echo "Started up container ${CORVEXCONTAINER}. Following log."
echo ""
docker logs -f ${CORVEXCONTAINER}
