ARG centos=8.3.2011
FROM aursu/centos:${centos}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_14.x"
ARG NODE_VERSION="14.15.2"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/8/x86_64/nodesource-release-el8-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL

RUN dnf -y module disable nodejs \
    && dnf -y install \
        nodejs-${NODE_VERSION} \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
