ARG centos=stream9-20240226.1
FROM aursu/centos:${centos}-base

RUN microdnf -y install \
		git \
		openssh-clients \
		rsync \
		findutils \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
