#!/usr/bin/env bash

set -e
set -o pipefail

# Script for Git repos housing edX services. These repos are mounted as
# data volumes into their corresponding Docker containers to facilitate development.
# Repos are cloned to/removed from the directory above the one housing this file.

#export COMPOSE_PROJECT_NAME=devstack

if [ -z "$COMPOSE_PROJECT_NAME" ]; then
    echo "need to set project name"
    exit 1
fi

volumes=(
    "mysql"
    "mongo"
)

_backup()
{
    volumes_to_backup=("$@")
    for volume in "${volumes_to_backup[@]}"
    do
        if docker volume inspect ${COMPOSE_PROJECT_NAME}_${volume}_data_bak > /dev/null ; then
            echo backup volume exists. removing backup volumes
            docker volume rm ${COMPOSE_PROJECT_NAME}_${volume}_data_bak
        fi
        ./docker_clone_volume.sh ${COMPOSE_PROJECT_NAME}_${volume}_data ${COMPOSE_PROJECT_NAME}_${volume}_data_bak
    done
}

backup()
{
    _backup  "${volumes[@]}"
}


backup

