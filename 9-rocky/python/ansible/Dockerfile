ARG rocky=9.4.20240523
FROM aursu/rockylinux:${rocky}-python3.12

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
        bash-completion \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

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
    && ansible-config init --disabled -t all  > ~/.ansible.cfg \
    && activate-global-python-argcomplete --user \
    && echo 'source ~/ansible-env/bin/activate' >> /var/ansible/.bashrc \
    && rm -rf /var/ansible/.cache
