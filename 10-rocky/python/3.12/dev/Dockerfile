ARG rocky=10.2.20260525.0
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.12

# No virtualenv here. A container is already the isolation boundary, and the
# venv only created a second interpreter to reason about: `python3` and
# `pytest` resolved to /var/ansible/.venv while the system interpreter had none
# of the packages. One interpreter, one site-packages.
#
# It also removes a coupling to one user: the venv lived in /var/ansible and
# the entrypoint activated it from ~, so the image served uid 1000 only —
# started as root it failed outright on /root/.venv/bin/activate. Packages now
# live in /usr/local and are visible to every user, which is why the entrypoint
# is gone too: it existed only to source the venv.
#
# `python3` comes from the parent image, where the python3 package IS 3.12 and
# `python-unversioned-command` supplies the unversioned names — el9 needs a
# symlink for this, el10 does not. Consumers that add packages of their own
# should install them under `USER root`; left as `ansible`, pip silently falls
# back to a --user install into ~/.local, whose bin directory is NOT on PATH in
# a `RUN`.
RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
    bash-completion \
    vim \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

# PyJWT[crypto] + cryptography are baked in here rather than in a consumer
# layer: RS256 JWT signing (GitHub App token exchange and similar) is generic
# enough to belong to the dev image, and abi3 wheels mean no C toolchain is
# pulled in. cryptography is pinned explicitly even though PyJWT's crypto extra
# (and ansible-core downstream) only declare it unbounded.
#
# argcomplete registers into /etc/bash_completion.d rather than `--user`: the
# packages now serve every user, so the completion should too.
RUN /usr/bin/python3.12 -m pip install --no-cache-dir \
            "PyYAML==6.0.3" \
            "pytest==9.1.1" \
            "argcomplete==3.7.0" \
            "PyJWT[crypto]==2.13.0" \
            "cryptography==50.0.0" \
    && activate-global-python-argcomplete --dest=/etc/bash_completion.d

USER ansible
WORKDIR /var/ansible

CMD ["/bin/bash"]
