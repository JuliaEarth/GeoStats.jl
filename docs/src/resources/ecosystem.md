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

Originally created to host the GeoStats.jl framework, this initiative is primarily
concerned with **geospatial data science** and **geostatistical modeling**.
Due to the various applications in the subsurface of the Earth, most of our
Julia packages were developed to work efficiently with both 2D and 3D geometries.

Unlike other initiatives, **JuliaEarth** is **100% Julia by design**. This means
that we do not rely on external libraries such as GDAL or Proj4 for geospatial
work.

## JuliaClimate

The most recent of the three initiatives, **JuliaClimate** has been created
to address specific challenges in climate modeling. One of these challenges
is access to climate data in Julia. Packages such as
[INMET.jl](https://github.com/JuliaClimate/INMET.jl) and
[CDSAPI.jl](https://github.com/JuliaClimate/CDSAPI.jl)
serve this purpose and are quite nice to work with.

## JuliaGeo

Focused on bringing well-established external libraries to Julia,
**JuliaGeo** provides packages that are widely used by geospatial
communities from other programming languages.
[GDAL.jl](https://github.com/JuliaGeo/GDAL.jl),
[Proj4.jl](https://github.com/JuliaGeo/Proj4.jl) and
[LibGEOS.jl](https://github.com/JuliaGeo/LibGEOS.jl)
are good examples of such packages.
