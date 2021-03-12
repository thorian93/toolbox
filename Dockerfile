FROM fedora:latest

LABEL maintainer="info@thorian93.de"

ARG USER=user

# SSH
RUN dnf -y upgrade && dnf -y install openssh-server passwd sudo

RUN \
useradd -d /home/${USER} ${USER} && \
echo "${USER}" | passwd ${USER} --stdin && \
usermod -aG wheel ${USER}

WORKDIR ./
COPY sshd_config /etc/ssh/sshd_config
COPY id_rsa.pub /home/${USER}/.ssh/authorized_keys

RUN \
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# Ansible
RUN dnf -y install ansible
WORKDIR ./
COPY ansible.cfg /etc/ansible/ansible.cfg

# Terraform
RUN dnf -y install dnf-plugins-core && \
dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
dnf -y install terraform

# Clean Up
RUN dnf -y remove passwd dnf-plugins-core && dnf -y autoremove && dnf clean all

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
