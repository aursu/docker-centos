ARG rocky=8.10.20240528
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-22-openjdk \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
