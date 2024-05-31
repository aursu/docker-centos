
ARG rocky=8.9.20231119
ARG image=scm
FROM aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="26.1.3"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
