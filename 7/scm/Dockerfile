ARG centos=7.7.1908
FROM aursu/centos:${centos}-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

