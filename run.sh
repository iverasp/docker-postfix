#!/bin/bash -e

# A script for running this image at the iegget deployment. See the README file for details.
# Moreover, it uses tozd/docker-hosts for service discovery and mounts its volume (/srv/var/hosts).

mkdir -p /srv/var/log/postfix
mkdir -p /srv/postfix
mkdir -p /srv/sympa/etc/shared

docker stop mail || true
sleep 1
docker rm mail || true
sleep 1
docker run --detach=true --restart=always --name mail --hostname mail.iegget.no \
 --publish 10.0.0.18:25:25/tcp --publish 10.0.0.18:465:465/tcp --publish 10.0.0.18:587:587/tcp \
 --env MAILNAME=mail.iegget.no \
 --env MY_NETWORKS='10.0.0.0/24 192.168.104.0/24 127.0.0.0/8' \
 --env ROOT_ALIAS='iver@iegget.no' \
 --env MY_DESTINATION='localhost.localdomain, localhost, mail.iegget.no' \
 --volume /srv/var/hosts:/etc/hosts:ro \
 --volume /srv/var/log/postfix:/var/log/postfix \
 --volume /srv/postfix:/var/spool/postfix \
 --volume /srv/sympa/etc/shared:/etc/sympa/shared \
 iverasp/postfix
