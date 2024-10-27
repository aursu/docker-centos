ARG rocky=9.4.20240523
FROM aursu/rockylinux:${rocky}-python3.12

RUN groupadd -g 1000 ansible \
    && useradd ansible -u 1000 -g 1000 -d /var/ansible -m

RUN microdnf -y install \
        bash-completion \
    && microdnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

USER ansible
WORKDIR /var/ansible

RUN python3.12 -m venv ansible-env \
    && source ansible-env/bin/activate \
    && python3.12 -m pip install --upgrade pip \
    && python3.12 -m pip install ansible-core argcomplete \
    && ansible-config init --disabled -t all  > ~/.ansible.cfg \
    && activate-global-python-argcomplete --user \
    && echo 'source ansible-env/bin/activate' >> /var/ansible/.bash_profile \
    && rm -rf /var/ansible/.cache
