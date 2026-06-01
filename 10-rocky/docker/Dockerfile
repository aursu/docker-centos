
ARG rocky=10.1.20251126
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="29.5.2"
ARG COMPOSE_VERSION="5.1.4"
ARG BUILDX_VERSION="0.34.1"
ARG MODEL_VERSION="1.2.1"
ARG SCOUT_VERSION="1.21.0"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-buildx-plugin-${BUILDX_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
		docker-model-plugin-${MODEL_VERSION} \
	&& curl -sSfL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh | sh -s -- -b /usr/libexec/docker/cli-plugins v${SCOUT_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
