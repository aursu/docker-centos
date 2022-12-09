ARG rocky=8.7.20221112
FROM aursu/rockylinux:${rocky}-base

RUN microdnf -y install \
		git \
		openssh-clients \
		rsync \
	&& dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
