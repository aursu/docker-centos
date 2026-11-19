# Parent: CentOS Stream Container Minimal 9 OCI image, built into
# aursu/centos:stream-container-minimal-9-<build>.x86_64 by the procedure in
# README.md, "CentOS Stream base images".
FROM aursu/centos:stream-container-minimal-9-20261118.0.x86_64

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
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-9 \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
