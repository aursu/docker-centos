FROM aursu/centos:stream8-base

RUN dnf -y install \
		git \
		openssh-clients \
		rsync \
	&& dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
