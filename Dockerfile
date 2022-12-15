FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    # system basic packages
    apt-get install -y curl less vim htop zsh sudo jq unzip nfs-common systemd openssh-server \
        software-properties-common

# install more python versions
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3-dev python3-venv sqlite3 python3.10 && \
    apt-get clean

# install cuda 11.5
RUN cd /tmp && \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-get update && \
    apt-get -y install cuda-11-5 && \
    apt-get clean

# moar tools. consolidate with the top one
RUN apt-get install -y git python3.10-full
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10

# create a virtual environment to use
RUN python3.10 -m venv /venv && \
    /venv/bin/python -m pip install \
        --no-cache-dir \
        --extra-index-url https://download.pytorch.org/whl/cu115 \
        torch torchvision torchaudio


# zsh goodies
RUN curl -L git.io/antigen > /root/antigen.zsh
RUN chsh -s /usr/bin/zsh root
ADD zshrc /root/.zshrc

# tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# vast cli
RUN wget https://raw.githubusercontent.com/vast-ai/vast-python/master/vast.py \
        -O /usr/local/bin/vast && \
    chmod +x /usr/local/bin/vast 

# start scripts
ADD onstart.sh /root/onstart.sh


CMD ["/bin/bash"]