ARG rocky=10.2.20260525.0
FROM ghcr.io/aursu/rockylinux:${rocky}-python3.12-dev

ARG SOPS_VERSION="3.13.2"
ARG SOPS_DISTRO="sops-v${SOPS_VERSION}.linux.amd64"
ARG SOPS_CHECKSUMS="sops-v${SOPS_VERSION}.checksums.txt"

USER root

RUN microdnf -y install \
    gnupg2 \
    pinentry \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

# Protecting Ansible secrets with SOPS
# https://docs.ansible.com/ansible/latest/collections/community/sops/docsite/guide.html#protecting-ansible-secrets-with-sops
RUN curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/${SOPS_CHECKSUMS} \
    && curl -LO https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/${SOPS_DISTRO} \
    && sha256sum -c ${SOPS_CHECKSUMS} --ignore-missing \
    && install -m0755 ${SOPS_DISTRO} /usr/local/bin/sops \
    && rm -f ${SOPS_CHECKSUMS} ${SOPS_DISTRO}

COPY --chown=ansible:ansible conf/gnupg /var/ansible/.gnupg
RUN install -d -m 0700 -o ansible -g ansible /var/ansible/.cache/gnupg

COPY --chown=ansible:ansible conf/bash /var/ansible/.bashrc.d

COPY conf/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

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
RUN pip install \
           "ansible-core==2.21.1" \
           "ansible-dev-tools==26.7.1" \
    && rm -rf /var/ansible/.cache/pip

# ansible-config init --disabled -t all  > ~/.ansible.cfg
COPY --chown=ansible:ansible conf/ansible.cfg /var/ansible/.ansible.cfg

# Install Ansible collections from the project's requirements.yml.
# Bumping a collection version or adding a new one is a one-line edit to the file;
# Docker's layer cache invalidates only this step.
COPY --chown=ansible:ansible conf/requirements.yml requirements.yml

RUN ansible-galaxy collection install -r requirements.yml \
    && rm -f requirements.yml
