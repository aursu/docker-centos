ARG rocky=9.7.20251123
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& microdnf -y update \
	    curl \
		glib2 \
		gnupg2 \
		gnutls \
		libarchive \
		libbrotli \
		libcap \
		libcurl \
		libnghttp2 \
		libssh \
		libxml2 \
		openssl-libs \
	&& microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
	    epel-release \
		glibc-langpack-en \
		shadow-utils \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
