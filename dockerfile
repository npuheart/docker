################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  nvidia/cuda:12.8.1-base-ubuntu24.04 AS builder
ENV TZ=Asia/Shanghai
ENV LANG=zh_CN.UTF-8
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

# Step 2 : Install Spack
FROM builder AS release
RUN apt-get update && \
    apt-get install -yq gcc g++ gfortran make cmake git && \
    apt-get install -yq xz-utils bzip2 zip && \
    cd /root && wget https://github.com/spack/spack/releases/download/v${SPACK_VERSION}/spack-${SPACK_VERSION}.tar.gz && tar -zxf spack-${SPACK_VERSION}.tar.gz && \
    rm /root/spack-${SPACK_VERSION}.tar.gz && \
    mv /root/spack-${SPACK_VERSION} /root/spack && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Step 3 : Install gcc
RUN . ~/spack/share/spack/setup-env.sh && \
    spack install gcc@11.4.0 && \
    spack load gcc@11.4.0 && \
    gcc --version && \
    spack compiler find && \
    spack clean --all



# RUN . ~/spack/share/spack/setup-env.sh && spack install gcc@11.4.0
# RUN . ~/spack/share/spack/setup-env.sh && spack env create fenics_kokkos && spack env activate fenics_kokkos -p
# RUN cat /root/.spack/packages.yaml