ARG rocky=8.10.20240528
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.6 AS builder

RUN microdnf -y install \
        --nodocs \
        --setopt=install_weak_deps=0 \
        mariadb-connector-c-devel \
        gcc \
        python3-devel

RUN /usr/bin/python3.6 \
        -m pip wheel \
        --no-cache-dir \
        --wheel-dir /root/workspace/wheels \
        'mysqlclient==2.1.1'

FROM ghcr.io/aursu/rockylinux:${rocky}-python3.6

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
        --nodocs \
        --setopt=install_weak_deps=0 \
        bash-completion \
        mariadb-connector-c \
        vim \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

COPY --from=builder /root/workspace/wheels /tmp/wheels

RUN /usr/bin/python3.6 \
        -m pip install \
        --no-cache-dir --no-index \
        --find-links /tmp/wheels \
        mysqlclient \
    && rm -rf /tmp/wheels

# No virtualenv here. A container is already the isolation boundary, and the
# venv only created a second interpreter to reason about: `python3` and
# `pytest` resolved to /var/ansible/.venv while /usr/bin/python3 had none of
# the packages. One interpreter, one site-packages.
#
# It also removes a bootstrap trap: `python3 -m venv` on 3.6 seeds the new
# environment from el8's bundled ensurepip, i.e. pip 9.0.3 - too old to
# install cryptography, so the venv form *had* to upgrade pip first. Installing
# into the system interpreter uses the pip that the parent image already
# provides via get-pip.py (21.3.1, the last release supporting 3.6).
#
# PyJWT[crypto] + cryptography are baked in here rather than in a consumer
# layer: RS256 JWT signing (GitHub App token exchange and similar) is generic
# enough to belong to the dev image, and abi3 wheels mean no C toolchain is
# pulled in. cryptography is pinned explicitly even though PyJWT's crypto extra
# (and ansible-core downstream) only declare it unbounded.
RUN /usr/bin/python3.6 -m pip install --no-cache-dir \
            "PyYAML==6.0.1" \
            "pytest==7.0.1" \
            "argcomplete==3.1.2" \
            "PyJWT[crypto]==2.4.0" \
            "cryptography==40.0.2" \
            'zeep==4.1.0' \
    && activate-global-python-argcomplete --dest=/etc/bash_completion.d

USER ansible
WORKDIR /var/ansible

CMD ["/bin/bash"]
