#!/bin/bash
set -e

# detects if the container is started for the first time
CONTAINER_FIRST_STARTUP="CONTAINER_FIRST_STARTUP"
STORAGE_CONTAINER_NAME="samples-workitems"

# if container is started for the first time:
# - restore tools
# - install dependencies
# - build the application
# - create storage container
if [ ! -e /var/cache/$CONTAINER_FIRST_STARTUP ]; then
    mkdir -p /var/cache/

    dotnet tool restore && dotnet build

    az storage container create -n $STORAGE_CONTAINER_NAME --connection-string $AzureWebJobsStorage

    sudo touch /var/cache/$CONTAINER_FIRST_STARTUP
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"