# Ecosystem

The Julia ecosystem for geospatial modeling is maturing very quickly
as the result of multiple initiatives such as
[JuliaEarth](https://github.com/JuliaEarth),
[JuliaClimate](https://github.com/JuliaClimate),
and [JuliaGeo](https://github.com/JuliaGeo). Each of these initiatives
is associated with a different set of challenges that ultimatively determine
the types of packages that are being developed in the corresponding GitHub
organizations. In this section, we try to clarify what is available to
first-time users of the language.

```@raw html
<img src="https://avatars.githubusercontent.com/u/59541313?s=200&v=4" width="150">
<img src="https://avatars.githubusercontent.com/u/41747566?s=200&v=4" width="150">
<img src="https://avatars.githubusercontent.com/u/10616454?s=200&v=4" width="150">
```

## JuliaEarth

Originally created to host the GeoStats.jl stack of packages, this
initiative is primarily concerned with **statistical modeling** of
geospatial processes. Due to the various  applications of geostatistics
in the subsurface of the Earth, most of our packages were developed to
work well with both 2D and 3D geometries, i.e. high-performance has
always been our priority from the start.

Unlike other initiatives, JuliaEarth is **100% Julia by design**.
This means that we do not rely on external libraries such as GDAL
and Proj4 in our implementations. Consequently, we may lack
important features at this point in time.

## JuliaClimate

The most recent of the three initiatives, JuliaClimate has been created
to address specific challenges in climate modeling. One of these challenges
is simply getting access to climate data in a format that is easy to consume
in Julia. Packages such as
[INMET.jl](https://github.com/JuliaClimate/INMET.jl) and
[CDSAPI.jl](https://github.com/JuliaClimate/CDSAPI.jl)
serve this purpose and are quite nice to work with. Additionally, other
packages such as
[ClimateTools.jl](https://github.com/JuliaClimate/ClimateTools.jl)
were developed to help with the computation of climate indices on
2D grids that are standard in climate sciences.

## JuliaGeo

Focused on bringing well-established external libraries to Julia,
JuliaGeo provides packages that are widely used by the geospatial
community from other programming languages.
[GDAL.jl](https://github.com/JuliaGeo/GDAL.jl),
[Proj4.jl](https://github.com/JuliaGeo/Proj4.jl) and
[LibGEOS.jl](https://github.com/JuliaGeo/LibGEOS.jl)
are good examples of such packages, which are often used as indirect
dependencies in Julia projects. Additionally, this initiative provides
packages for IO such as
[Shapefile.jl](https://github.com/JuliaGeo/Shapefile.jl) and
[GeoJSON.jl](https://github.com/JuliaGeo/GeoJSON.jl) that are written
in pure Julia and can be easily installed anywhere.

## Miscellaneous

Besides the three main initiatives listed above, various other initiatives
can be found that are related to computational geometry and visualization
of geometric models. We highlight the
[Meshes.jl](https://github.com/JuliaGeometry/Meshes.jl)
project hosted in the
[JuliaGeometry](https://github.com/JuliaGeometry)
organization, the
[Makie.jl](https://github.com/JuliaPlots/Makie.jl)
project hosted in the
[JuliaPlots](https://github.com/JuliaPlots)
organization, as well as other packages
for loading/saving mesh data such as
[Gmsh.jl](https://github.com/JuliaFEM/Gmsh.jl),
[PlyIO.jl](https://github.com/JuliaGeometry/PlyIO.jl),
[ReadVTK.jl](https://github.com/trixi-framework/ReadVTK.jl) and
[WriteVTK.jl](https://github.com/jipolanco/WriteVTK.jl).