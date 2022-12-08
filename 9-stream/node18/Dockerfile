ARG centos=stream9-20221206.0
FROM aursu/centos:${centos}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_18.x"
ARG NODE_VERSION="18.12.1"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/9/x86_64/nodesource-release-el9-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && microdnf -y module disable nodejs \
    && microdnf -y install \
        nodejs-${NODE_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
