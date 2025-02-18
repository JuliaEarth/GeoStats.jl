# Can I access the raw coordinates?

```@example coords
using GeoStats # hide
import CairoMakie as Mke # hide
```

Access to the raw coordinates of geometries stored in the `geometry` column is discouraged.
If you make good use of the high-level transforms provided by the framework, you will be more
productive.

## Solid motion

Coordinates are often called for when the application requires solid motion. We provide optimized
`Translate`, `Rotate` and `Scale` transforms for that purpose:

```@example coords
data = georef((; z=rand(1000, 1000)))
```

```@example coords
data |> Translate(10u"m", 8u"ft")
```

## Projections

Map projections are examples of coordinate transforms. The `Proj` function can be used to "reproject"
a `GeoTable` into a new coordinate reference system (`CRS`):

```@example coords
data |> Proj(Polar)
```

## Direct access

If you really need access to the coordinates, use the `coords` function:

```@example coords
quad = data.geometry[1]
```

```@example coords
point = centroid(quad)
```

```@example coords
coords(point)
```

It returns a `CRS` object. The type of this object can be retrieved with the `crs` function,
which works with any `GeoTable`, geospatial `Domain` or individual `Geometry`:

```@example coords
crs(data)
```

Very often the coordinates are `LatLon` in degrees. These cannot be used in linear algebra
routines. The function `to` converts any `CRS` object into a static vector with `Cartesian`
coordinates for algebraic manipulation:

```@example coords
to(Point(LatLon(0, 0)))
```
