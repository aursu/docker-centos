ARG rocky=10.1.20251126
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.12

ARG SOPS_VERSION="3.11.0"
ARG SOPS_DISTRO="sops-v${SOPS_VERSION}.linux.amd64"
ARG SOPS_CHECKSUMS="sops-v${SOPS_VERSION}.checksums.txt"

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
    bash-completion \
    gnupg2 \
    pinentry \
    vim \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

# Protecting Ansible secrets with SOPS
# https://docs.ansible.com/ansible/latest/collections/community/sops/docsite/guide.html#protecting-ansible-secrets-with-sops
RUN curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/${SOPS_CHECKSUMS} \
    && curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/${SOPS_DISTRO} \
    && sha256sum -c ${SOPS_CHECKSUMS} --ignore-missing \
    && install -m0755 ${SOPS_DISTRO} /usr/local/bin/sops \
    && rm -f ${SOPS_CHECKSUMS} ${SOPS_DISTRO}

COPY --chown=ansible:ansible conf/gnupg /var/ansible/.gnupg
COPY --chown=ansible:ansible conf/bash /var/ansible/.bashrc.d

USER ansible
WORKDIR /var/ansible

# Installing and upgrading Ansible with pip
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible-with-pip
#
# Adding Ansible command shell completion
# https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#adding-ansible-command-shell-completion
#
# Getting the latest configuration
# https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html#configuration-file
#
# The configuration file
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#the-configuration-file
RUN python -m venv ansible-env \
    && source ansible-env/bin/activate \
    && python -m pip install --upgrade pip \
    && python -m pip install ansible-core ansible-dev-tools argcomplete \
    && activate-global-python-argcomplete --user  \
    && rm -rf /var/ansible/.cache/pip \
    && mkdir -p /var/ansible/.cache/gnupg

# ansible-config init --disabled -t all  > ~/.ansible.cfg
COPY --chown=ansible:ansible conf/ansible.cfg /var/ansible/.ansible.cfg

RUN source ansible-env/bin/activate \
    && ansible-galaxy collection install \
        community.sops \
        community.general \
        ansible.posix \
        community.crypto
