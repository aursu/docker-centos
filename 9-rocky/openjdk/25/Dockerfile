ARG rocky=9.6.20250531
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-latest-openjdk-1:25.0.1.0.8 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
