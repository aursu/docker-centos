ARG rocky=8.10.20240528
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		python36-3.6.8 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& curl -sS https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3 \
	&& rm -rf /root/.cache
