ARG rocky=8.10.20240528
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
&& microdnf -y update \
	gnutls \
	libxml2 \
	krb5-libs \
	libarchive \
	openssl-libs \
	glib2 \
	libnghttp2 \
	sqlite-libs \
	libacl \
	gnupg2 \
	libcap \
	libtasn1 \
	openldap \
	bzip2-libs \
	curl \
	libmount \
	libgcrypt \
	lz4-libs \
	libgcc \
	libuuid \
	libblkid \
	libsolv \
	libstdc++ \
	libsmartcols \
	bash \
	ca-certificates \
	rocky-release \
	tzdata \
&& microdnf -y install \
	--nodocs \
	--setopt=install_weak_deps=0 \
	epel-release \
	glibc-langpack-en \
	openssl \
	shadow-utils \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
