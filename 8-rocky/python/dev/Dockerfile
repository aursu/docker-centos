ARG rocky=8.10.20240528
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.6

ENV PATH="/var/ansible/.venv/bin:${PATH}"
ENV VIRTUAL_ENV="/var/ansible/.venv"

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
    bash-completion \
    vim \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

COPY --chown=ansible:ansible conf/bash /var/ansible/.bashrc.d

COPY conf/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER ansible
WORKDIR /var/ansible

# PyJWT[crypto] + cryptography are baked in here rather than in a consumer
# layer: RS256 JWT signing (GitHub App token exchange and similar) is generic
# enough to belong to the dev venv, and abi3 wheels mean no C toolchain is
# pulled in. cryptography is pinned explicitly even though PyJWT's crypto extra
# (and ansible-core downstream) only declare it unbounded.
RUN python3 -m venv --prompt .venv .venv \
    && pip install --upgrade pip \
    && pip install \
            "PyYAML==6.0.1" \
            "pytest==7.0.1" \
            "argcomplete==3.1.2" \
            "PyJWT[crypto]==2.4.0" \
            "cryptography==40.0.2" \
    && activate-global-python-argcomplete --user \
    && rm -rf /var/ansible/.cache/pip

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
