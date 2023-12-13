ARG rocky=8.8.20230518
FROM aursu/rockylinux:${rocky}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_18.x"
ARG NODE_VERSION="18.19.0"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && microdnf -y module disable nodejs \
    && microdnf -y install \
        nodejs-${NODE_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
