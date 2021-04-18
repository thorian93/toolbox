FROM fedora:latest

LABEL maintainer="info@thorian93.de"

ARG USER=user
ARG PROJECT_PATH=/opt/project

ENV PROJECT_PATH=${PROJECT_PATH}

RUN \
dnf -y upgrade && \
dnf -y install passwd sudo

# Ansible
RUN dnf -y install ansible
WORKDIR ./
COPY ansible.cfg /etc/ansible/ansible.cfg

# Terraform
RUN dnf -y install dnf-plugins-core && \
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
dnf -y install terraform

# User config and entry script
WORKDIR ./
COPY start.sh /start.sh
RUN \
useradd -d /home/${USER} ${USER} && \
echo "${USER}" | passwd ${USER} --stdin && \
usermod -aG wheel ${USER} && \
mkdir ${PROJECT_PATH} && \
chmod +x /start.sh

# Clean Up
RUN dnf -y remove passwd dnf-plugins-core && dnf -y autoremove && dnf clean all

ENTRYPOINT ["/start.sh"]
