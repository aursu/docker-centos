FROM centos:8

RUN set -ex \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial \
	&& yum -y install epel-release \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8 \
	&& yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
