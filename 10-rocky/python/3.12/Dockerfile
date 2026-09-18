ARG rocky=10.2.20260525.0
ARG image=scm
FROM ghcr.io/aursu/rockylinux:${rocky}-${image}

# RL10's platform python IS 3.12 and ships the unversioned command, so the
# packages are taken unpinned: a micro-version pin on python3 only ever drifts
# out of step with python-unversioned-command, which is what broke the build.
# The version is asserted instead, so a distro that ever moves its platform
# python fails the build loudly rather than producing a mislabelled image.
RUN microdnf -y install \
		--nodocs \
		--setopt=install_weak_deps=0 \
		python3 \
		python-unversioned-command \
    && python3 --version | grep -q '^Python 3\.12\.' \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
	&& rm -rf /root/.cache
