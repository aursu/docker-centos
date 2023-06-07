ARG rocky=8.8.20230518
FROM aursu/rockylinux:${rocky}-base

RUN microdnf -y install \
		git \
		openssh-clients \
		rsync \
	&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
