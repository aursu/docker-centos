ARG rocky=10.1.20251126
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		python3.12-3.12.13 \
		python3.12-pip \
		python-unversioned-command \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
