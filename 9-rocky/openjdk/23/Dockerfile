ARG rocky=9.5.20241118
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-latest-openjdk-23.0.2.0.7 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
