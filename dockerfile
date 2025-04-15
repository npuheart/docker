################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  nvidia/cuda:12.8.1-base-ubuntu24.04 AS builder
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
ENV SPACK_VERSION=v1.0.0-alpha.4
ENV GCC_VERSION=14.2.0

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

# Create user 'npuheart' with password 'npuheart'
RUN apt-get update && \
    apt-get install -yq sudo && \
    useradd -m -s /bin/bash npuheart && \
    echo "npuheart:npuheart" | chpasswd && \
    echo "npuheart ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Step 2 : Install Spack
FROM builder AS release
# Switch to 'npuheart' user and set home directory
USER npuheart
WORKDIR /home/npuheart

# Step 2: Install system dependencies (run as root temporarily)
USER root
RUN apt-get update && \
    apt-get install -yq gcc g++ gfortran make cmake git && \
    apt-get install -yq xz-utils bzip2 zip zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Step 3: Install Spack as 'npuheart'
USER npuheart
RUN wget https://github.com/spack/spack/archive/refs/tags/${SPACK_VERSION}.tar.gz && \
    tar -zxf ${SPACK_VERSION}.tar.gz && \
    rm ${SPACK_VERSION}.tar.gz && \
    mv spack-* spack

# Step 3 : Install gcc
RUN . ~/spack/share/spack/setup-env.sh && \
    spack install gcc@${GCC_VERSION} && \
    spack load gcc@${GCC_VERSION} && \
    gcc --version && \
    spack compiler find && \
    spack clean --all


    
# RUN . ~/spack/share/spack/setup-env.sh && spack install gcc@11.4.0
# RUN . ~/spack/share/spack/setup-env.sh && spack env create fenics_kokkos && spack env activate fenics_kokkos -p
# RUN cat /root/.spack/packages.yaml