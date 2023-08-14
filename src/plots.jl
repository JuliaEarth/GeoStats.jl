# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
    hscatter(data, var₁, var₂; [options])

H-scatter plot of geospatial `data` for pair of variables
`var₁` and `var₂` with additional `options`.

## Algorithm options:

* `lag`           - lag distance between points (default to `0.0`)
* `tol`           - tolerance for lag distance (default to `1e-1`)
* `distance`      - distance from Distances.jl (default to `Euclidean()`)

## Aesthetics options:

* `size`          - size of points in point set
* `color`         - color of geometries or points
* `alpha`         - transparency channel in [0,1]
* `colorscheme`   - color scheme from ColorSchemes.jl
* `rcolor`        - color of regression line
* `icolor`        - color of identity line
* `ccolor`        - color of center lines

## Examples

```
# h-scatter of Z vs. Z at lag 1.0
hscatter(data, :Z, :Z, lag=1.0)

# h-scatter of Z vs. W at lag 2.0
hscatter(data, :Z, :W, lag=2.0)
```

### Notes

* This function will only work in the presence of
  a Makie.jl backend via package extensions in
  Julia v1.9 or later versions of the language.
"""
function hscatter end
function hscatter! end

"""
    varioplot(γ; [options])

Plot the variogram or varioplane `γ` with given `options`.

## Empirical variogram options:

* `vcolor` - color of variogram
* `psize`  - size of points of variogram
* `ssize`  - size of segments of variogram
* `tshow`  - show text counts
* `tsize`  - size of text counts
* `hshow`  - show histogram
* `hcolor` - color of histogram

## Empirical varioplane options:

* `vscheme` - color scheme of varioplane
* `rshow`   - show range of theoretical model
* `rmodel`  - theoretical model (e.g. `SphericalVariogram`)
* `rcolor`  - color of range curve

## Theoretical variogram options:

* `maxlag` - maximum lag for theoretical model

### Notes

* This function will only work in the presence of
  a Makie.jl backend via package extensions in
  Julia v1.9 or later versions of the language.
"""
function varioplot end
function varioplot! end

"""
    viewer(data; kwargs...)

Basic scientific viewer for geospatial `data`.

Aesthetic options are forwarded via `kwargs` to
the [`viz`](@ref) recipe.
"""
function viewer end

export
  # recipes
  hscatter,
  varioplot,

  # functions
  viewer
