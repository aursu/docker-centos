ARG rocky=8.9.20231119
FROM aursu/rockylinux:${rocky}-base

RUN microdnf -y install \
		findutils \
		git \
		openssh-clients \
		procps \
		rsync \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
