FROM mcr.microsoft.com/vscode/devcontainers/dotnet:6.0

ARG USER="vscode"
ARG WORKDIR="/app"
ARG PUBLISHDIR="/home/site/wwwroot"

ENV AzureWebJobsScriptRoot=${PUBLISHDIR} \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# install azure cli and azure functions cli
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
    && sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs | cut -d'.' -f 1)/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list' \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends azure-functions-core-tools-4 \
    && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

COPY --chown=${USER}:${USER} . ${WORKDIR}

WORKDIR ${WORKDIR}

RUN mkdir -p ${PUBLISHDIR} \
    && dotnet publish *.fsproj --output ${PUBLISHDIR} \
    && chown -R ${USER}:${USER} bin/ \
    && chown -R ${USER}:${USER} obj/ \
    && sudo chown -R ${USER}:${USER} /tmp/NuGetScratch/

USER ${USER}

CMD [ "func", "start" ]

# FROM mcr.microsoft.com/dotnet/sdk:5.0 AS installer-env

# # Build requires 3.1 SDK
# COPY --from=mcr.microsoft.com/dotnet/core/sdk:3.1 /usr/share/dotnet /usr/share/dotnet

# COPY . /src/dotnet-function-app
# RUN cd /src/dotnet-function-app && \
#     mkdir -p /home/site/wwwroot && \
#     dotnet publish *.csproj --output /home/site/wwwroot

# # To enable ssh & remote debugging on app service change the base image to the one below
# # FROM mcr.microsoft.com/azure-functions/dotnet-isolated:3.0-dotnet-isolated5.0-appservice
# FROM mcr.microsoft.com/azure-functions/dotnet-isolated:3.0-dotnet-isolated5.0
# ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
#     AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# COPY --from=installer-env ["/home/site/wwwroot", "/home/site/wwwroot"]

