ARG centos=8.3.2011
FROM aursu/centos:${centos}-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

