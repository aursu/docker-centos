FROM centos:7.6.1810

RUN set -ex \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
	&& yum -y install epel-release \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
