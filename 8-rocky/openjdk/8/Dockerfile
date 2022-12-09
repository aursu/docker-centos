ARG rocky=8.7.20221112
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-1.8.0-openjdk \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
