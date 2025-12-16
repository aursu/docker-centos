ARG rocky=9.7.20251123
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install glibc-devel \
	&& microdnf -y module enable ruby:3.1 \
	&& microdnf -y install \
		ruby \
		ruby-devel \
		make \
		gcc-c++ \
		redhat-rpm-config \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
