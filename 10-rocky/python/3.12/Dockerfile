ARG rocky=10.0.20250606
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		python3-3.12.9 \
		python3-pip \
		python-unversioned-command \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
