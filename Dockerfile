FROM nvidia/cuda:11.5.1-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    # system basic packages
    apt install -y curl ssh systemd less vim htop zsh sudo jq unzip nfs-common \
        software-properties-common

# tailscale repo
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg -o /usr/share/keyrings/tailscale-archive-keyring.gpg  && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list -o /etc/apt/sources.list.d/tailscale.list && \
    # python repo
    add-apt-repository ppa:deadsnakes/ppa

# install extras
RUN apt update && apt install -y tailscale python3-dev python3-venv sqlite3 && \
    apt-get clean

# Don't start any optional services except for the few we need.
# Extras:
#  1. SSH
#  2. Tailscale
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -not -name '*ssh*' \
    -not -name '*tailscale*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target
STOPSIGNAL SIGRTMIN+3

# ssh setup
COPY ssh-host-key.service /etc/systemd/system/
RUN chmod 664 /etc/systemd/system/ssh-host-key.service
RUN systemctl enable ssh-host-key.service

# pwdless user setup
RUN useradd -ms /bin/bash ml && \
    usermod -aG sudo ml && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD authorized_keys /home/ml/.ssh/authorized_keys
RUN chmod 700 /home/ml/.ssh && \
    chown ml:ml /home/ml/.ssh -R && \
    chmod 600 /home/ml/.ssh/authorized_keys 

CMD ["/sbin/init", "--log-target=journal"]