# Docker Images Used by npuheart  

## Mesh Processing  
So far, the primary task has been converting meshes in VTK, XDA (IBAMR), CASE (EnSight), and MSH (GMSH) formats into XDMF (HDF5) files.  

There are two related branches:  
1. **`fenics` branch** – Built on the older Ubuntu 20.04 base, providing only two functions:  
   - Generating XDMF-format meshes  
   - Handling XML-format mesh functions (fiber directions, material properties, boundary types, etc.)  
2. **`mesh` branch** – Built on the newer Ubuntu 24.04 base, designed to read newer mesh formats using PyVista and other tools. It converts meshes into text files for easier data reading in containers based on the `fenics` image.

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