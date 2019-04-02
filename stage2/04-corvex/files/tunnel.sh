#!/bin/sh

sleep 180


autossh -f -N -i /home/corvex/tunnel_key -R *:11803:127.0.0.1:80 -R *:18803:127.0.0.1:8888 -R *:11003:127.0.0.1:22 ccs@db1.corvexconnected.com 2>&1 
