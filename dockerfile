################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  ubuntu:20.04 AS builder
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV UID=1010
ENV GID=1010

# 设置root用户密码为root
RUN echo 'root:root' |chpasswd  
# 设置非交互式安装        
ARG DEBIAN_FRONTEND=noninteractive

# Install SSH
RUN apt-get update && \
    apt-get install -yq openssh-server && \
    mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh/ && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    apt-get install -yq gcc g++ gfortran make cmake git && \
    apt-get install -yq xz-utils bzip2 zip unzip wget vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    apt-get install -yq sudo && \
    groupadd -g ${GID} simcardiac && \
    useradd -m -s /bin/bash -u ${UID} -g ${GID} simcardiac && \
    echo "simcardiac:simcardiac" | chpasswd && \
    echo "simcardiac ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    apt-get install -yq fenics && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER simcardiac
WORKDIR /home/simcardiac






    