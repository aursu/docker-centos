ARG rocky=8.10.20240528
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf module enable ruby:3.1 \
	&& microdnf -y --enablerepo=powertools install \
		ruby \
		ruby-devel \
		make \
		gcc-c++ \
		redhat-rpm-config \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
