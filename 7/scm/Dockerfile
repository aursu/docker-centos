FROM aursu/centos:7-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

