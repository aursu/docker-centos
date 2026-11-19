ARG rocky=10.3.20261112.0
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

LABEL org.opencontainers.image.source=https://github.com/aursu/docker-centos

# source: https://github.com/cli/cli/releases
# The gh-cli repository keeps only the latest release: once upstream publishes
# a newer one, this pin stops resolving and the build fails until it is bumped.
# EPEL also ships an older gh; the exact version selects the gh-cli build.
ARG GH_VERSION="2.105.0"

COPY system/etc/yum.repos.d/gh-cli.repo /etc/yum.repos.d/gh-cli.repo

RUN set -ex \
	&& microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		gh-${GH_VERSION} \
	&& gh --version \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
