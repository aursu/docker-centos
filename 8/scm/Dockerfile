ARG centos=8.1.1911
FROM aursu/centos:${centos}-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

