ARG rocky=9.9.20261112.0
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-25-openjdk-1:25.0.5.0.8 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
