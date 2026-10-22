ARG rocky=8.10.20240528
FROM ghcr.io/aursu/rockylinux:${rocky}-webdev

ARG NODE_VERSION="24.x"
ARG NODEJS_VERSION="24.22.1"
ARG NPM_VERSION="11.21.1"
ARG YARN_VERSION="4.18.1"

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

# Corepack's activated yarn must be visible to every uid (the image runs as
# `node` or an arbitrary --user), not only to root's ~/.cache; world-writable
# so a project pinning another yarn via packageManager can still download it.
ENV COREPACK_HOME=/usr/local/share/corepack

RUN microdnf -y module disable nodejs \
  && microdnf -y install \
    curl \
    nodejs-${NODEJS_VERSION} \
    tar \
    which \
  && export npm_install=${NPM_VERSION} \
  && curl -f -L -s https://www.npmjs.com/install.sh | sh \
  && corepack enable \
  && corepack prepare yarn@${YARN_VERSION} --activate \
  && chmod -R a+rwX ${COREPACK_HOME} \
  && rm -rf /root/.npm \
  && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
