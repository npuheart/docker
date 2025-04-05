# https://hub.docker.com/r/nvidia/cuda
FROM ubuntu:24.04

ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
RUN echo 'root:root' |chpasswd
ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get update

# Install SSH
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh/
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config


RUN apt-get install python3-pip -y
RUN python3 -m venv ./venv && source ./venv/bin/activate && pip3 install pyvista numpy

RUN ssh-keygen -A
EXPOSE 22

