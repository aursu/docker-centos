ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-webdev

ARG NODE_VERSION="22.x"
ARG NODEJS_VERSION="22.22.2"
ARG NPM_VERSION="11.12.1"
ARG YARN_VERSION="4.13.0"

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

RUN cat <<EOF > /etc/yum.repos.d/nodesource-nodejs.repo
[nodesource-nodejs]
name=Node.js Packages for Linux RPM based distros - \$basearch
baseurl=https://rpm.nodesource.com/pub_${NODE_VERSION}/nodistro/nodejs/\$basearch
priority=9
enabled=1
gpgcheck=1
gpgkey=https://rpm.nodesource.com/gpgkey/ns-operations-public.key
module_hotfixes=1
EOF

RUN cat <<EOF > /etc/yum.repos.d/nodesource-nsolid.repo
[nodesource-nsolid]
name=N|Solid Packages for Linux RPM based distros - \$basearch
baseurl=https://rpm.nodesource.com/pub_${NODE_VERSION}/nodistro/nsolid/\$basearch
priority=9
enabled=1
gpgcheck=1
gpgkey=https://rpm.nodesource.com/gpgkey/ns-operations-public.key
module_hotfixes=1
EOF

RUN rpm --import https://rpm.nodesource.com/gpgkey/ns-operations-public.key

RUN microdnf -y install \
    curl \
    nodejs-${NODEJS_VERSION} \
    tar \
    which \
  && export npm_install=${NPM_VERSION} \
  && curl -f -L -s https://www.npmjs.com/install.sh | sh \
  && corepack enable \
  && corepack prepare yarn@${YARN_VERSION} --activate \
  && rm -rf /root/.npm \
  && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
