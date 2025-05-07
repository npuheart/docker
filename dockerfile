################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  nvidia/cuda:12.6.3-devel-ubuntu24.04 AS builder
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV UID=1010
ENV GID=1010
ENV SPACK_VERSION=0.23.0

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
    groupadd -g ${GID} npuheart && \
    useradd -m -s /bin/bash -u ${UID} -g ${GID} npuheart && \
    echo "npuheart:npuheart" | chpasswd && \
    echo "npuheart ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER npuheart
WORKDIR /home/npuheart

RUN wget https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz && \
    tar -zxf spack-${SPACK_VERSION}.tar.gz && \
    rm spack-${SPACK_VERSION}.tar.gz && \
    mv spack-${SPACK_VERSION} spack

# Step 4 : Install
ADD config/packages-1.yaml /home/npuheart/.spack/packages.yaml
RUN sudo chown -R npuheart:npuheart /home/npuheart/.spack
RUN . ~/spack/share/spack/setup-env.sh && spack env create gpus
ADD gpus.yaml gpus.yaml
RUN sudo chown npuheart:npuheart gpus.yaml
RUN mv config/spack-openmpi.yaml spack/var/spack/environments/gpus/spack.yaml
RUN . ~/spack/share/spack/setup-env.sh && \
    spack env activate -p gpus && \
    spack concretize -f && \
    spack install && \
    spack env deactivate && \
    spack clean --all





    