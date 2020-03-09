FROM aursu/centos:7.7.1908-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
		java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
