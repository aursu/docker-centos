ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-21-openjdk-1:21.0.9.0.10 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
