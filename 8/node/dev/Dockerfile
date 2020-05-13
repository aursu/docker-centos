ARG centos=8.1.1911
FROM aursu/centos:${centos}-webdev

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_13.x"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/8/x86_64/nodesource-release-el8-1.noarch.rpm"

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
        nodejs-13.14.0 \
        yarn-1.22.4 \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*