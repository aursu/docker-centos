ARG centos=7.9.2009
FROM centos:${centos}

RUN set -ex \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
	&& yum -y install \
		ca-certificates \
		epel-release \
		tzdata \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*
