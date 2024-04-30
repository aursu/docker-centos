ARG centos=stream9-20240429.0
FROM aursu/centos:${centos}-scm

RUN microdnf -y install \
		bzip2 \
		unzip \
		xz \
		java-17-openjdk \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
