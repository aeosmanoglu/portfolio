ARG VARIANT=2-bullseye
FROM ruby:${VARIANT}

COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/

ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get purge -y imagemagick imagemagick-6-common \
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && bash /tmp/library-scripts/ruby-debian.sh "none" "${USERNAME}" "true" "true" \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
ARG NODE_VERSION="none"
ENV NVM_DIR=/usr/local/share/nvm
ENV NVM_SYMLINK_CURRENT=true \
    PATH=${NVM_DIR}/current/bin:${PATH}
RUN bash /tmp/library-scripts/node-debian.sh "${NVM_DIR}" "${NODE_VERSION}" "${USERNAME}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/library-scripts