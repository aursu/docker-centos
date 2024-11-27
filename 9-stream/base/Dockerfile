# curl  https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Container-Minimal-9-20241125.0.x86_64.tar.xz | docker load
# docker tag centos-stream-container-minimal-9-20241125.0.x86_64:latest aursu/centos:stream-container-minimal-9-20241125.0.x86_64
FROM aursu/centos:stream-container-minimal-9-20241125.0.x86_64

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
