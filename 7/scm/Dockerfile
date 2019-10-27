FROM aursu/centos:8-base

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

