# npuheart 使用的 docker 镜像

## 网格
到目前为止，主要将 vtk, xda(IBAMR), case(ensight), msh(Gmsh) 格式的网格转换成 xdmf(h5) 格式的文件。
与之相关的有两个分支，一个是 fenics 分支，一个是 mesh 分支，fenics 分支基于较老的 ubuntu 20.04 版本构建，
只提供两个功能：
1. 生成 xdmf 格式的网格
2. xml 格式的 mesh function (纤维方向，材料属性，边界类型等等)
mesh 分支基于较新的 ubuntu 24.04 分支，用于读取格式较新的网格，使用 pyvista 等功能，将网格转换成文本文件，
以便于以便于在基于fenics镜像的容器中读取这些数据


