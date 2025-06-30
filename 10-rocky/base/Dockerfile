ARG rocky=10.0.20250606
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& microdnf -y update \
		centos-gpg-keys \
		centos-stream-release \
		centos-stream-repos \
	&& microdnf -y install \
		crypto-policies-scripts \
		epel-release \
		glibc-langpack-en \
		shadow-utils \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-10 \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
