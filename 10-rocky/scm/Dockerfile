ARG rocky=10.0.20250606
FROM aursu/rockylinux:${rocky}-base

RUN microdnf -y install \
		findutils \
		git \
		openssh-clients \
		procps \
		rsync \
		openssl \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
