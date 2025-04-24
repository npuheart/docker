

# ARG CUDA_VERSION=12.4.0
FROM ubuntu:24.04

RUN apt-get update
RUN apt-get install -y wget
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
RUN apt-get update
RUN apt-get install -y cuda-toolkit
RUN apt-get install -y nvidia-gds
RUN apt-get install -y tensorrt
    && rm -rf /var/lib/apt/lists/*
# RUN dpkg -i cuda-keyring_1.1-1_all.deb


RUN wget https://developer.download.nvidia.com/compute/machine-learning/tensorrt/10.9.0/local_repo/nv-tensorrt-local-repo-ubuntu2404-10.9.0-cuda-12.8_1.0-1_amd64.deb

# FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu22.04
# LABEL maintainer="NVIDIA CORPORATION"

# ENV NV_CUDNN_VERSION 8.9.6.50
# ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

# ENV CUDA_VERSION_MAJOR_MINOR=12.2

# ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda${CUDA_VERSION_MAJOR_MINOR}"
# ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda${CUDA_VERSION_MAJOR_MINOR}"

# ENV TRT_VERSION 10.0.1.6
# SHELL ["/bin/bash", "-c"]

# RUN apt-get update && apt-get install -y --no-install-recommends \
#     ${NV_CUDNN_PACKAGE} \
#     ${NV_CUDNN_PACKAGE_DEV} \
#     && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
#     && rm -rf /var/lib/apt/lists/*

# # Setup user account
# ARG uid=1000
# ARG gid=1000
# RUN groupadd -r -f -g ${gid} trtuser && useradd -o -r -l -u ${uid} -g ${gid} -ms /bin/bash trtuser
# RUN usermod -aG sudo trtuser
# RUN echo 'trtuser:nvidia' | chpasswd
# RUN mkdir -p /workspace && chown trtuser /workspace

# # Required to build Ubuntu 20.04 without user prompts with DLFW container
# ENV DEBIAN_FRONTEND=noninteractive

# # Update CUDA signing key
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub

# # Install requried libraries
# RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository ppa:ubuntu-toolchain-r/test
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     libcurl4-openssl-dev \
#     wget \
#     git \
#     pkg-config \
#     sudo \
#     ssh \
#     libssl-dev \
#     pbzip2 \
#     pv \
#     bzip2 \
#     unzip \
#     devscripts \
#     lintian \
#     fakeroot \
#     dh-make \
#     build-essential

# # Install python3
# RUN apt-get install -y --no-install-recommends \
#       python3 \
#       python3-pip \
#       python3-dev \
#       python3-wheel &&\
#     cd /usr/local/bin &&\
#     ln -s /usr/bin/python3 python &&\
#     ln -s /usr/bin/pip3 pip;

# # Install TensorRT
# RUN if [ "${CUDA_VERSION:0:2}" = "11" ]; then \
#     wget https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/10.0.1/tars/TensorRT-10.0.1.6.Linux.x86_64-gnu.cuda-11.8.tar.gz \
#         && tar -xf TensorRT-10.0.1.6.Linux.x86_64-gnu.cuda-11.8.tar.gz \
#         && cp -a TensorRT-10.0.1.6/lib/*.so* /usr/lib/x86_64-linux-gnu \
#         && pip install TensorRT-10.0.1.6/python/tensorrt-10.0.1-cp310-none-linux_x86_64.whl ;\
# elif [ "${CUDA_VERSION:0:2}" = "12" ]; then \
#     wget https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/10.0.1/tars/TensorRT-10.0.1.6.Linux.x86_64-gnu.cuda-12.4.tar.gz \
#         && tar -xf TensorRT-10.0.1.6.Linux.x86_64-gnu.cuda-12.4.tar.gz \
#         && cp -a TensorRT-10.0.1.6/lib/*.so* /usr/lib/x86_64-linux-gnu \
#         && pip install TensorRT-10.0.1.6/python/tensorrt-10.0.1-cp310-none-linux_x86_64.whl ;\
# else \
#     echo "Invalid CUDA_VERSION"; \
#     exit 1; \
# fi

# # Install PyPI packages
# RUN pip3 install --upgrade pip
# RUN pip3 install setuptools>=41.0.0
# COPY requirements.txt /tmp/requirements.txt
# RUN pip3 install -r /tmp/requirements.txt
# RUN pip3 install jupyter jupyterlab
# # Workaround to remove numpy installed with tensorflow
# RUN pip3 install --upgrade numpy

# # Install Cmake
# RUN cd /tmp && \
#     wget https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh && \
#     chmod +x cmake-3.14.4-Linux-x86_64.sh && \
#     ./cmake-3.14.4-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
#     rm ./cmake-3.14.4-Linux-x86_64.sh

# # Download NGC client
# RUN cd /usr/local/bin && wget https://ngc.nvidia.com/downloads/ngccli_cat_linux.zip && unzip ngccli_cat_linux.zip && chmod u+x ngc-cli/ngc && rm ngccli_cat_linux.zip ngc-cli.md5 && echo "no-apikey\nascii\n" | ngc-cli/ngc config set

# # Set environment and working directory
# ENV TRT_LIBPATH /usr/lib/x86_64-linux-gnu
# ENV TRT_OSSPATH /workspace/TensorRT
# ENV PATH="${PATH}:/usr/local/bin/ngc-cli"
# ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TRT_OSSPATH}/build/out:${TRT_LIBPATH}"
# WORKDIR /workspace

# USER trtuser
# RUN ["/bin/bash"]
