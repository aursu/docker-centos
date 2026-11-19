ARG rocky=9.9.20261112.0
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

# python3.12 is the ONLY interpreter here. el9's `python3` package is 3.9, and
# `python-unversioned-command` is 3.9 as well, so neither may be installed —
# they would add a second, older interpreter and point `python3` at it. The
# unversioned names are symlinks instead, in /usr/local/bin: that directory
# precedes /usr/bin on PATH and is where get-pip.py puts pip/pip3/pip3.12 too,
# so every Python entry point lives in one place. RL10 needs none of this — its
# python3 package IS 3.12 and ships the unversioned command.
# source: microdnf repoquery --available python3.12
ARG PYTHON_VERSION="3.12.16"
# source: https://pypi.org/project/pip/
ARG PIP_VERSION="26.3"
RUN microdnf -y install \
		python3.12-${PYTHON_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& ln -s /usr/bin/python3.12 /usr/local/bin/python3 \
	&& ln -s /usr/bin/python3.12 /usr/local/bin/python \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 - "pip==${PIP_VERSION}" \
	&& rm -rf /root/.cache
