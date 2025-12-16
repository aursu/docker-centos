ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		python3.12 \
		python3.12-pip \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
