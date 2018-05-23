FROM centos:6-scm

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

# create rpmbuild structure for user root
RUN mkdir -p \
          /root/rpmbuild/SRPMS \
          /root/rpmbuild/RPMS \
          /root/rpmbuild/SPECS \
          /root/rpmbuild/SOURCES

VOLUME ["/root/rpmbuild/SRPMS", "/root/rpmbuild/RPMS"]

WORKDIR /root/rpmbuild/SPECS
CMD ["/bin/bash"]
