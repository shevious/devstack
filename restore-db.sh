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

_restore()
{
    volumes_to_restore=("$@")
    for volume in "${volumes_to_restore[@]}"
    do
        if ! docker volume inspect ${COMPOSE_PROJECT_NAME}_${volume}_data_bak > /dev/null ; then
            echo no backup volume ${COMPOSE_PROJECT_NAME}_${volume}_data_bak exists
            #docker volume rm ${COMPOSE_PROJECT_NAME}_${volume}_data_bak
        else
            if docker volume inspect ${COMPOSE_PROJECT_NAME}_${volume}_data > /dev/null ; then
                echo erasing volume ${COMPOSE_PROJECT_NAME}_${volume}_data
                docker volume rm ${COMPOSE_PROJECT_NAME}_${volume}_data
            fi
            echo ./docker_clone_volume.sh ${COMPOSE_PROJECT_NAME}_${volume}_data_bak ${COMPOSE_PROJECT_NAME}_${volume}_data
        fi
    done
}

restore()
{
    _restore  "${volumes[@]}"
}


restore

