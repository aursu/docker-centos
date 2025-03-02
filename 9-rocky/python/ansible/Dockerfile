ARG rocky=9.4.20240523
FROM aursu/rockylinux:${rocky}-python3.12

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
    bash-completion \
    pinentry \
    vim \
&& microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

# Protecting Ansible secrets with SOPS
# https://docs.ansible.com/ansible/latest/collections/community/sops/docsite/guide.html#protecting-ansible-secrets-with-sops
RUN curl -LO https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.checksums.txt \
    && curl -LO https://github.com/getsops/sops/releases/download/v3.9.4/sops-v3.9.4.linux.amd64 \
    && sha256sum -c sops-v3.9.4.checksums.txt --ignore-missing \
    && install -m0755 sops-v3.9.4.linux.amd64 /usr/local/bin/sops \
    && rm -f sops-v3.9.4.checksums.txt sops-v3.9.4.linux.amd64

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
RUN python3.12 -m venv ansible-env \
    && source ansible-env/bin/activate \
    && python3.12 -m pip install --upgrade pip \
    && python3.12 -m pip install ansible-core argcomplete \
    && activate-global-python-argcomplete --user  \
    && rm -rf /var/ansible/.cache/pip \
    && mkdir -p /var/ansible/.cache/gnupg

# ansible-config init --disabled -t all  > ~/.ansible.cfg
COPY --chown=ansible:ansible conf/ansible.cfg /var/ansible/.ansible.cfg

RUN source ansible-env/bin/activate \
    && ansible-galaxy collection install \
        community.sops \
        community.general \
        ansible.posix
