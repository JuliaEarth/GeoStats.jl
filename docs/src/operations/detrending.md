# Detrending

## Overview

Spatial data can be detrended in place:

```@docs
detrend!
```

Alternatively, the trend can be obtained without mutating
the input data:

```@docs
trend
```

## Example

```@example
using GeoStats # hide
using Plots # hide
gr(format=:svg) # hide

# quadratic + noise
r = range(-1,stop=1,length=100)
μ = [x^2 + y^2 for x in r, y in r]
ϵ = 0.1rand(100,100)
𝒟 = georef((z=μ+ϵ,))

ℳ = trend(𝒟, :z, degree=2)

plot(plot(𝒟), plot(ℳ))
```
