ARG rocky=9.5.20241118
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y module enable ruby:3.3 \
	&& microdnf -y install \
		ruby \
		ruby-devel \
		make \
		gcc-c++ \
		redhat-rpm-config \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
