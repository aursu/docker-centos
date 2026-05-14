ARG rocky=9.7.20251123
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		python3.12 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
	&& rm -rf /root/.cache
