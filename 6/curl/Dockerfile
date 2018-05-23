FROM centos:6

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6 && yum -y update

RUN yum -y install epel-release \
	&& yum clean all && rm -rf /var/cache/yum

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

RUN yum -y install \
		ca-certificates \
		curl \
		wget \
	&& yum clean all && rm -rf /var/cache/yum
