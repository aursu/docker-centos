ARG centos=8.4.2105
FROM aursu/centos:${centos}

# no weak dependencies
COPY system/etc/dnf/dnf.conf /etc/dnf/dnf.conf

RUN set -ex \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial \
	&& yum -y install epel-release \
	&& rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8 \
	&& yum clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
