#!/bin/bash
docker volume rm `docker volume ls -q -f dangling=true | grep '................................................................'`
