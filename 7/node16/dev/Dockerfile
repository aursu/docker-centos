ARG centos=7.9.2009
FROM aursu/centos:${centos}-webdev

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_16.x"
ARG NODE_VERSION="16.20.2"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"
ARG YARN_VERSION="1.22.19"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo \
    && curl -sL https://dl.yarnpkg.com/rpm/pubkey.gpg -o /tmp/pubkey.gpg \
    && rpm --import /tmp/pubkey.gpg \
    && rm -rf /tmp/pubkey.gpg /var/cache/yum /var/lib/rpm/__db*

RUN yum -y install \
        nodejs-${NODE_VERSION} \
        yarn-${YARN_VERSION} \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
