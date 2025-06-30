
ARG rocky=9.6.20250531
ARG image=scm
FROM aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="28.1.1"
ARG COMPOSE_VERSION="2.35.1"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
