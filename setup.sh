#!/bin/bash
#
# Script to setup ML system from plain ubuntu 20.04. Designed for vast.ai, 
# this requires at a minimum 15 GB of disk space, 30GB+ recommended 
#
# Contains:
#   1. Base tools (wget, curl, less, vim, etc.)
#   2. CUDA 11.5
#   3. Python 3.10 (from deadsnakes PPA)
#   4. Root virtualenv at "/venv" with pytorch
#   5. ZSH with spaceship prompt
#   6. Git credentials

apt-get install -y curl less vim htop zsh sudo jq unzip nfs-common systemd \
    software-properties-common
