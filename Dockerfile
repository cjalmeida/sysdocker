FROM nvidia/cuda:11.5.1-runtime-ubuntu20.04

RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg -O /usr/share/keyrings/tailscale-archive-keyring.gpg  && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list -O /etc/apt/sources.list.d/tailscale.list && \
    apt update && \
    apt install -y ssh systemd tailscale
