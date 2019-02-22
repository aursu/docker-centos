FROM centos:7.6.1810

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && yum -y update

RUN yum -y install epel-release \
	&& yum clean all && rm -rf /var/cache/yum

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

RUN yum -y install \
		ca-certificates \
		curl \
		wget \
	&& yum clean all && rm -rf /var/cache/yum
