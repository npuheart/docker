################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  ghcr.io/npuheart/docker:v0.0.6 AS builder

# Step 4 : Install kokkos and fenics
RUN . ~/spack/share/spack/setup-env.sh && spack env create kokkos
ADD https://github.com/shaoyaoqian/docker-computing-images/releases/download/v0.04/spack-fenics-kokkos-2.yaml /root/spack/var/spack/environments/kokkos/spack.yaml
RUN . ~/spack/share/spack/setup-env.sh && \
    spack env activate -p kokkos && \
    spack concretize -f && \
    spack install && \
    spack env deactivate && \
    spack clean --all
