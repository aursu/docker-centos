ARG rocky=9.9.20261112.0
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-21-openjdk-1:21.0.13.0.9 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
