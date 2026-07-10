ARG rocky=10.2.20260525.0
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.12

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

RUN python3.12 -m venv .venv \
    && pip install --upgrade pip \
    && pip install \
            "PyYAML==6.0.3" \
            "pytest==9.1.1" \
            "argcomplete==3.7.0" \
    && activate-global-python-argcomplete --user \
    && rm -rf /var/ansible/.cache/pip

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
