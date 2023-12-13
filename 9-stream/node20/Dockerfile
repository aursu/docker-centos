ARG centos=stream9-20231016.0
FROM aursu/centos:${centos}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_20.x"
ARG NODE_VERSION="20.10.0"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-NODEJS-GPG-SIGNING-KEY-EL \
        /etc/pki/rpm-gpg/NODESOURCE-NSOLID-GPG-SIGNING-KEY-EL \
    && microdnf -y module disable nodejs \
    && update-crypto-policies --set DEFAULT:SHA1 \
    && microdnf -y install \
        nodejs-${NODE_VERSION} \
    && update-crypto-policies --set DEFAULT \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
