ARG rocky=10.0.20250606
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& microdnf -y install \
	    epel-release \
		glibc-langpack-en \
		shadow-utils \
		openssl \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
