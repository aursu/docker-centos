FROM quay.io/centos/centos:stream8

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& dnf -y install \
		epel-release \
		glibc-langpack-en \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8 \
	&& dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
