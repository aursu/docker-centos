ARG rocky=9.6.20250531
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-latest-openjdk-24.0.1.0.9 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
