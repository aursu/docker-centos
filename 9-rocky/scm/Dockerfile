ARG rocky=9.6.20250531
FROM ghcr.io/aursu/rockylinux:${rocky}-base

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

RUN microdnf -y install \
		findutils \
		git \
		openssh-clients \
		procps \
		rsync \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
