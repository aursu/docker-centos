
ARG rocky=9.9.20261112.0
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

ARG DOCKER_VERSION="29.4.3"
ARG COMPOSE_VERSION="5.1.3"
ARG SCOUT_VERSION="1.21.0"
# source: https://github.com/docker/scout-cli/releases (verified against the release checksums file)
ARG SCOUT_URL="https://github.com/docker/scout-cli/releases/download/v${SCOUT_VERSION}"

COPY system/etc/yum.repos.d/docker.repo /etc/yum.repos.d/docker.repo

RUN set -ex \
	&& microdnf -y install \
	    docker-ce-cli-${DOCKER_VERSION} \
		docker-compose-plugin-${COMPOSE_VERSION} \
		skopeo \
		tar \
	&& scout_tmp="$(mktemp -d)" && cd "$scout_tmp" \
	&& curl -fsSL -O "${SCOUT_URL}/docker-scout_${SCOUT_VERSION}_linux_amd64.tar.gz" \
	&& curl -fsSL -O "${SCOUT_URL}/docker-scout_${SCOUT_VERSION}_checksums.txt" \
	&& sha256sum --ignore-missing -c "docker-scout_${SCOUT_VERSION}_checksums.txt" \
	&& tar -xzf "docker-scout_${SCOUT_VERSION}_linux_amd64.tar.gz" docker-scout \
	&& install -m 0755 docker-scout /usr/libexec/docker/cli-plugins/docker-scout \
	&& cd / && rm -rf "$scout_tmp" \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
