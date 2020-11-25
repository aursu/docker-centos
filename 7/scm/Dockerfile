ARG centos=7.9.2009
FROM aursu/centos:${centos}-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

