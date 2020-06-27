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
```
