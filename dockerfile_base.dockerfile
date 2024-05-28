# docker build -t ubuntu-base-image:latest -f ./dockerfile_base.dockerfile .
# Customize it according to your project's requirements.

# Use an official dev container image (e.g., Ubuntu, Alpine, etc.)
# Specify the version/tag to ensure reproducibility.
FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Set metadata for the image (optional but recommended)
LABEL maintainer="Maxium <zsdezsc@gmail.com>"
LABEL description="Linux Devcontainer"

# Install system packages and dependencies
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        wget \
        git \
        curl \
        vim \
        tmux \
        zsh \
        sudo \
        man \
        locales \
        systemd \
        make

# you should put future package installation in update dockerfile, the unpacking of base:ubuntu is taking too long