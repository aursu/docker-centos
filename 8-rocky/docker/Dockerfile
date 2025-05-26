
ARG rocky=8.10.20240528
ARG image=scm
FROM aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="26.1.3"
ARG COMPOSE_VERSION="2.27.0"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
