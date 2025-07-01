
ARG rocky=10.0.20250606
ARG image=scm
FROM aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="28.3.0"
ARG COMPOSE_VERSION="2.37.3"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
