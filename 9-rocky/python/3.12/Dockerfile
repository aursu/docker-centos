ARG rocky=9.6.20250531
FROM aursu/rockylinux:${rocky}-scm

RUN microdnf -y install \
		python3.12 \
		python3.12-pip \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*
