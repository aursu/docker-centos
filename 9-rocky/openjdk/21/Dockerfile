ARG rocky=9.5.20241118
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-21-openjdk-21.0.5.0.11 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
