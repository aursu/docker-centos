ARG centos=8.1.1911
FROM aursu/centos:${centos}-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
		java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
