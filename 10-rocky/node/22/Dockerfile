ARG rocky=10.1.20251126
FROM ghcr.io/aursu/rockylinux:${rocky}-web

ARG NODE_VERSION="22.x"

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
      nodejs-22.22.0 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
