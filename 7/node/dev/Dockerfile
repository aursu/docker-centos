ARG centos=7.8.2003
FROM aursu/centos:${centos}-webdev

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_14.x"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL \
    && curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo \
    && curl -sL https://dl.yarnpkg.com/rpm/pubkey.gpg -o /tmp/pubkey.gpg \
    && rpm --import /tmp/pubkey.gpg \
    && rm -rf /tmp/pubkey.gpg /var/cache/yum /var/lib/rpm/__db*

RUN yum -y install \
        nodejs-14.2.0 \
        yarn-1.22.4 \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*