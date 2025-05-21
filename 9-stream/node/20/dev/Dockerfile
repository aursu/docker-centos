ARG centos=stream9-20250520.0
FROM aursu/centos:${centos}-webdev

COPY docker-entrypoint.sh /usr/local/libexec/

RUN groupadd -g 1000 node \
  && useradd -u 1000 -g node -s /bin/bash -m node \
  && chmod +x /usr/local/libexec/docker-entrypoint.sh

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_20.x"
ARG NODE_VERSION="20.16.0"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && update-crypto-policies --set DEFAULT:SHA1 \
    && rpm --import https://rpm.nodesource.com/gpgkey/ns-operations-public.key \
    && microdnf -y module disable nodejs \
    && microdnf -y install \
        nodejs-${NODE_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
    && corepack enable

ENTRYPOINT ["/usr/local/libexec/docker-entrypoint.sh"]
CMD [ "node" ]
