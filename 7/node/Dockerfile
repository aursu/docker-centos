ARG centos=7.9.2009
FROM aursu/centos:${centos}-web

# https://github.com/nodesource/distributions/blob/master/README.md#rpm
ARG NODEREPO="pub_14.x"
ARG RELEASE_URL="https://rpm.nodesource.com/${NODEREPO}/el/7/x86_64/nodesource-release-el7-1.noarch.rpm"

# install nodejs RPM repo
RUN set -ex \
    && rpm -Uvh ${RELEASE_URL} \
    && rpm --import /etc/pki/rpm-gpg/NODESOURCE-GPG-SIGNING-KEY-EL

RUN yum -y install \
        nodejs-14.2.0 \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*