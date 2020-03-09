ARG centos=6.10
FROM aursu/centos:${centos}-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN yum -y install java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
