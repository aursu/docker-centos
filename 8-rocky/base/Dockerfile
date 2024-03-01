ARG rocky=8.9.20231119
FROM quay.io/rockylinux/rockylinux:${rocky}-minimal

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& microdnf -y install \
	    epel-release \
		glibc-langpack-en \
		shadow-utils \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
