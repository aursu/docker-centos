FROM aursu/centos:6.10-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN yum -y install java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
