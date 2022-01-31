# Azure.Starter.Functions

This repo demonstrates the basics of getting a dotnet-sdk Azure Function running locally with Azure storage using Docker and Docker Compose.

## Overview

This is a simple starter template for developing a net6.0 Azure Function with F#. It uses docker compose to setup any necessary dependencies and as well as the development environment.

It uses Microsoft's official [`azurite`](https://github.com/Azure/Azurite) docker image to set up a local Azure storage server.

```bash
docker compose build
docker compose up
```

By default, the `docker-entrypoint.sh` startup script creates a `samples-workitems` container. Whenever a blob is uploaded to the container, the `ProcessBlob` function will be triggered.

## Development

```bash
# from outside the container
docker compose run --rm functions /bin/bash -c "az storage blob upload --file test.txt --container-name samples-workitems --connection-string $AzureWebJobsStorage"

# from inside the running container
az storage blob upload --file test.txt --container-name samples-workitems --connection-string $AzureWebJobsStorage
```

You can find the functions log here: `/app/bin/output/azure.starter.functions.log`.