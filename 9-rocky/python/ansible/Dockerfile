ARG rocky=9.4.20240523
FROM aursu/rockylinux:${rocky}-python3.12

RUN useradd ansible

USER ansible
WORKDIR /home/ansible

# RUN python3.12 -m venv ansible-env \
# 	&& source ansible-env/bin/activate \
# 	&& python3.12 -m pip install --upgrade pip \
# 	&& python3.12 -m pip install ansible-core \
# 	&& echo 'source ansible-env/bin/activate' >> /root/.bashrc
