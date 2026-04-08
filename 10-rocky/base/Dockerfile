ARG rocky=10.1.20251126
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& microdnf -y update \
	    crypto-policies \
		curl \
		glibc \
		glib2 \
		gnutls \
		libarchive \
		libssh \
		openssl-libs \
		rocky-release \
		shadow-utils \
		util-linux \
		zlib-ng-compat \
	&& microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		epel-release \
		glibc-langpack-en \
		openssl \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
