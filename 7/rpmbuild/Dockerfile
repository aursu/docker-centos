FROM centos:7-scm

ARG builduser=centos
ARG buildgroup=centos
ARG buildhome=/home/${builduser}

ENV BUILD_USER $builduser
ENV BUILD_TOPDIR ${buildhome}/rpmbuild

# apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
RUN groupadd -g 48 $buildgroup \
    && useradd -u 48 -g $buildgroup -d $buildhome -k /dev/null -m $BUILD_USER

# install RPM build tools and assets
RUN yum -y install \
        rpm-build \
        yum-utils \
        epel-rpm-macros \
    && yum clean all && rm -rf /var/cache/yum

# install common build tools (autotools, compilers, parsers etc)
RUN yum -y install \
        autoconf \
        bison \
        flex \
        gcc \
        gcc-c++ \
        libtool \
        make \
    && yum clean all && rm -rf /var/cache/yum

USER $BUILD_USER

# create rpmbuild structure for user root
RUN mkdir -p ${BUILD_TOPDIR}/{RPMS,SOURCES,SPECS,SRPMS}

VOLUME ${BUILD_TOPDIR}/SRPMS ${BUILD_TOPDIR}/RPMS

WORKDIR ${BUILD_TOPDIR}/SPECS
