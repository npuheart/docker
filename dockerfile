################################################################################
# Spack Dockerfile
################################################################################
# Step 1 : Create a base image
FROM  ghcr.io/npuheart/docker:v0.1.6 AS builder

# Step 4 : Install kokkos and fenics
ADD config/packages-1.yaml /root/.spack/packages.yaml
RUN . ~/spack/share/spack/setup-env.sh && spack env create kokkos
ADD config/spack-fenics-kokkos-3.yaml /root/spack/var/spack/environments/kokkos/spack.yaml
RUN . ~/spack/share/spack/setup-env.sh && \
    spack env activate -p kokkos && \
    spack concretize -f && \
    spack install && \
    spack env deactivate && \
    spack clean --all
