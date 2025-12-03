ARG rocky=10.0.20250606
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		ruby \
		ruby-devel \
		make \
		gcc-c++ \
		redhat-rpm-config \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
