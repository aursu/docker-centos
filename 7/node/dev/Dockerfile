FROM aursu/centos:7-webdev

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_11.x"
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
        nodejs \
        yarn \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*