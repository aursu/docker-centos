ARG centos=stream8
FROM aursu/centos:${centos}-scm

RUN dnf -y install \
		bzip2 \
		unzip \
		xz \
		java-1.8.0-openjdk \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
