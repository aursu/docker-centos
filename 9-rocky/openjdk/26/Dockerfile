ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-latest-openjdk-1:26.0.0.0.35 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
