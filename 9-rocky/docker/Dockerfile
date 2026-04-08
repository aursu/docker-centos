
ARG rocky=9.7.20251123
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="29.1.3"
ARG COMPOSE_VERSION="5.0.1"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
