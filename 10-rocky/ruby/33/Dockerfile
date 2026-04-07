ARG rocky=10.1.20251126
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

ARG RUBY_VERSION="3.3.10"

RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		ruby-${RUBY_VERSION} \
		ruby-devel-${RUBY_VERSION} \
		make \
		gcc-c++ \
		redhat-rpm-config \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
