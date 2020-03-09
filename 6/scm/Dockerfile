ARG centos=6.10
FROM aursu/centos:${centos}-curl

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
