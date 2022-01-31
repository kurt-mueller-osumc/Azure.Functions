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
    && chown -R ${USER}:${USER} /tmp/NuGetScratch/

USER ${USER}

CMD [ "func", "start" ]
