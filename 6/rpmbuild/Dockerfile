FROM centos:6-scm

RUN yum -y install \
                rpm-build \
                yum-utils \
                ldconfig_scriptlets \
        && yum clean all && rm -rf /var/cache/yum

RUN mkdir -p \
          /root/rpmbuild/SRPMS \
          /root/rpmbuild/RPMS \
          /root/rpmbuild/SPECS \
          /root/rpmbuild/SOURCES

VOLUME ["/root/rpmbuild/SRPMS", "/root/rpmbuild/RPMS"]

WORKDIR /root/rpmbuild/SPECS
CMD ["/bin/bash"]
