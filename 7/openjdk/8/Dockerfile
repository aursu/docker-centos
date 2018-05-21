FROM centos:7-scm

RUN yum -y install \
		bzip2 \
		unzip \
		xz \
	&& yum clean all && rm -rf /var/cache/yum 

RUN yum -y install java-1.8.0-openjdk \
    && yum clean all && rm -rf /var/cache/yum
