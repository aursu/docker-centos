ARG centos=stream9-20251215.0
FROM aursu/centos:${centos}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-latest-openjdk-22.0.2.0.9 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
