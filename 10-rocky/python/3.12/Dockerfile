ARG rocky=10.1.20251126
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

RUN microdnf -y install \
		python3-3.12.12 \
		python3-pip \
		python-unversioned-command \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
