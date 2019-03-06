FROM aursu/centos:7-scm

ARG DOCKER_VERSION=18.09.3
ARG COMPOSE_VERSION=1.23.2

RUN yum -y install \
		device-mapper-persistent-data \
		lvm2 \
		yum-utils \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

RUN yum -y install \
		docker-ce-${DOCKER_VERSION} \
	&& yum clean all && rm -rf /var/cache/yum /var/lib/rpm/__db*

RUN curl \
	-L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
	-o /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose
