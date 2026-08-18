ARG rocky=9.8.20260525.0
FROM ghcr.io/aursu/rockylinux:${rocky}-scm

# python3.12 is the ONLY interpreter here. el9's `python3` package is 3.9, and
# `python-unversioned-command` is 3.9 as well, so neither may be installed —
# they would add a second, older interpreter and point `python3` at it. The
# unversioned names are symlinks instead, in /usr/local/bin: that directory
# precedes /usr/bin on PATH and is where get-pip.py puts pip/pip3/pip3.12 too,
# so every Python entry point lives in one place. RL10 needs none of this — its
# python3 package IS 3.12 and ships the unversioned command.
RUN microdnf -y install \
		python3.12 \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db* \
	&& ln -s /usr/bin/python3.12 /usr/local/bin/python3 \
	&& ln -s /usr/bin/python3.12 /usr/local/bin/python \
	&& curl -sS https://bootstrap.pypa.io/get-pip.py | python3.12 \
	&& rm -rf /root/.cache
