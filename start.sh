#!/bin/sh

# Can use this for docker in docker, but the problem with this is the Docker cache

/usr/bin/dockerlaunch /usr/bin/docker daemon &
#printenv
sleep 5
/scripts/main.sh "$@"
