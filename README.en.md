# Docker Images Used by npuheart  


## 运行之前
docker已经支持
```
sudo docker run -it --rm --gpus all nvidia/cuda:12.8.1-base-ubuntu24.04 nvidia-smi
```

## Mesh Processing  
So far, the primary task has been converting meshes in VTK, XDA (IBAMR), CASE (EnSight), and MSH (GMSH) formats into XDMF (HDF5) files.  

There are two related branches:  
1. **`fenics` branch** – Built on the older Ubuntu 20.04 base, providing only two functions:  
   - Generating XDMF-format meshes  
   - Handling XML-format mesh functions (fiber directions, material properties, boundary types, etc.)  
2. **`mesh` branch** – Built on the newer Ubuntu 24.04 base, designed to read newer mesh formats using PyVista and other tools. It converts meshes into text files for easier data reading in containers based on the `fenics` image.

```
sudo docker run -it ghcr.io/npuheart/docker:v0.0.5 /bin/bash
sudo docker run -it ghcr.io/npuheart/docker:v0.0.3 /bin/bash
```


## IB-FEniCS

WIP



## Poromechanics

WIP



## SimCardiac v1.0

CPU-GPU (finished)

## SimCardiac v2.0

IB-MPM

## SimCardiac v3.0

fully GPU (finished)

## SimCardiac v4.0

Direct forcing-IB-poromechanics

## SimCardiac v5.0

IB-GNN

## SimCardiac v6.0

IB-MPM

## SimCardiac v7.0

IB-MPM

# 可用的镜像

#### ghcr.io/npuheart/docker:v0.0.6
- nvidia/cuda:12.8.1-base-ubuntu24.04
- gcc 11.4.0
- spack 0.23.0

-----------------------------------
#### ghcr.io/npuheart/docker:v0.0.7
- ghcr.io/npuheart/docker:v0.0.6
- [config/spack-fenics-kokkos-1.yaml](config/spack-fenics-kokkos-1.yaml)

-----------------------------------
#### ghcr.io/npuheart/docker:v0.1.6
- nvidia/cuda:12.6.3-devel-ubuntu24.04
- gcc 11.4.0
- spack 0.23.0

-----------------------------------
#### ghcr.io/npuheart/docker:v0.1.7
- ghcr.io/npuheart/docker:v0.1.7
- [config/spack-fenics-kokkos-1.yaml](config/spack-fenics-kokkos-1.yaml)
- [config/packages-1.yaml](config/packages-1.yaml)


-----------------------------------
#### ghcr.io/npuheart/docker:v0.1.7-post1
- ghcr.io/npuheart/docker:v0.1.6
- [config/spack-fenics-kokkos-3.yaml](config/spack-fenics-kokkos-3.yaml)
- [config/packages-1.yaml](config/packages-1.yaml)
在这个镜像上可运行 `tag:v0.1.7-post1` , 左心室的舒张与收缩。
