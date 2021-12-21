ARG centos=8.4.2105
FROM aursu/centos:${centos}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_16.x"
ARG NODE_VERSION="16.13.1"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/8/x86_64/nodesource-release-el8-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && dnf -y module disable nodejs \
    && dnf -y install \
        nodejs-${NODE_VERSION} \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
