################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  ubuntu:24.04 AS builder
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV UID=1010
ENV GID=1010
ENV SPACK_VERSION=0.23.0
ENV SPACK_FENICS=fenics

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

RUN . ~/spack/share/spack/setup-env.sh && \
    spack install gcc@11.4.0 && \
    spack load gcc@11.4.0 && \
    spack compiler find && \
    spack clean --all

# Step 4 : Install
RUN . ~/spack/share/spack/setup-env.sh && spack env create ${SPACK_FENICS}
ADD config/spack-fenics-1.yaml ${SPACK_FENICS}.yaml
RUN sudo chown npuheart:npuheart ${SPACK_FENICS}.yaml
RUN mv ${SPACK_FENICS}.yaml spack/var/spack/environments/${SPACK_FENICS}/spack.yaml

RUN . ~/spack/share/spack/setup-env.sh && \
    spack env activate -p ${SPACK_FENICS} && \
    spack concretize -f && \
    spack install && \
    spack env deactivate && \
    spack clean --all
