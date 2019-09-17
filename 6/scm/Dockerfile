FROM aursu/centos:6-curl

RUN yum -y install \
		git \
		openssh-clients \
		rsync \
	&& yum clean all && rm -rf /var/cache/yum
