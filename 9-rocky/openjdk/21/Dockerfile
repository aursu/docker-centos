ARG rocky=9.6.20250531
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-21-openjdk-21.0.8.0.9 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
