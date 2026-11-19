ARG rocky=10.3.20261112.0
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

# RL10's platform python IS 3.12 and ships the unversioned command. The two
# packages must be the same version (python-unversioned-command requires its
# own python3 exactly), so both are pinned to it and bumped together.
# source: microdnf repoquery --available python3 python-unversioned-command
ARG PYTHON_VERSION="3.12.16"
# source: https://pypi.org/project/pip/
ARG PIP_VERSION="26.3"
RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		python3-${PYTHON_VERSION} \
		python-unversioned-command-${PYTHON_VERSION} \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 - "pip==${PIP_VERSION}" \
	&& rm -rf /root/.cache
