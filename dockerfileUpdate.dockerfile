# update/upgrade the base image
# docker build -t ubuntu-base-image:latest -f ./dockerfileUpdate.dockerfile .
# FROM ubuntu-base-image:latest

# docker build --build-arg BASE_IMAGE=ubuntu:latest -t ubuntu-base-image:latest -f ./dockerfileUpdate.dockerfile .
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Install system packages and dependencies
RUN apt-get update && apt-get upgrade -y
        # Add more packages here as needed

# Unminimize the image, only for one time use
# RUN yes | unminimize