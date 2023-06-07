ARG rocky=8.8.20230518
FROM aursu/rockylinux:${rocky}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_16.x"
ARG NODE_VERSION="16.19.1"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/8/x86_64/nodesource-release-el8-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && microdnf -y module disable nodejs \
    && microdnf -y install \
        nodejs-${NODE_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
