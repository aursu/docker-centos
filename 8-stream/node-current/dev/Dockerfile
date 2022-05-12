ARG centos=stream8
FROM aursu/centos:${centos}-webdev

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_18.x"
ARG NODE_VERSION="18.1.0"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/8/x86_64/nodesource-release-el8-1.noarch.rpm"
ARG YARN_VERSION="1.22.18"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo \
    && curl -sL https://dl.yarnpkg.com/rpm/pubkey.gpg -o /tmp/pubkey.gpg \
    && rpm --import /tmp/pubkey.gpg \
    && rm -rf /tmp/pubkey.gpg /var/cache/dnf /var/lib/rpm/__db*

RUN dnf -y module disable nodejs \
    && dnf -y install \
        nodejs-${NODE_VERSION} \
        yarn-${YARN_VERSION} \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
