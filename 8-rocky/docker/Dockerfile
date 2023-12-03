
ARG rocky=8.8.20230518
ARG image=scm
FROM aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="24.0.7"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
