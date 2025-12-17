
ARG rocky=10.1.20251126
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="29.1.3"
ARG COMPOSE_VERSION="5.0.0"
ARG BUILDX_VERSION="0.30.1"
ARG MODEL_VERSION="1.0.5"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-buildx-plugin-${BUILDX_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
		docker-model-plugin-${MODEL_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
