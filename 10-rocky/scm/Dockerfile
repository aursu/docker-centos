ARG rocky=10.3.20261112.0
FROM ghcr.io/aursu/rockylinux:${rocky}-base

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		diffutils \
		findutils \
		git \
		openssh-clients \
		procps \
		rsync \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
