ARG centos=7.8.2003
FROM aursu/centos:${centos}-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
		java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
