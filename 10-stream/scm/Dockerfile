ARG centos=stream10-20250520.0
FROM aursu/centos:${centos}-base

RUN microdnf -y install \
		findutils \
		git \
		openssh-clients \
		procps \
		rsync \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
