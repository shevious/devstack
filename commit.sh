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

containers=(
    "discovery"
    "credentials"
    "forum"
    "lms"
    "studio"
    "ecommerce"
    "edx_notes_api"
    "devpi"
)

_commit()
{
    containers_to_commit=("$@")
    for container in "${containers_to_commit[@]}"
    do
        docker commit edx.devstack.$container ${COMPOSE_PROJECT_NAME}.$container
    done
}

commit()
{
    _commit  "${containers[@]}"
}


commit

