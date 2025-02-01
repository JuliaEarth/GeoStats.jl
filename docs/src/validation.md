# Validation

## Overview

We provide various geostatistical cross-validation methods to compare
[interpolation models](interpolation.md) or [learning models](learning.md).
These methods are accessible through the [`cverror`](@ref) function:

```@docs
cverror
```

As an example, consider the block cross-validation error of the following
decision tree learning model:

```@example error
using GeoStats
using GeoIO

# load geospatial data
Ω = GeoIO.load("data/agriculture.csv", coords = ("x", "y"))

# 20%/80% split along the (1, -1) direction
Ωₛ, Ωₜ = geosplit(Ω, 0.2, (1.0, -1.0))

# features and label for supervised learning
feats = ["band1", "band2", "band3", "band4"]
label = "crop"

# learning model
model = DecisionTreeClassifier()

# loss function
loss = MisclassLoss()

# block cross-validation with r = 30.
bcv = BlockValidation(30., loss = Dict("crop" => loss))

# estimate of generalization error
ϵ̂ = cverror((model, feats => label), Ωₛ, bcv)
```

We can unhide the labels in the target domain and compute the actual
error for comparison:

```@example error
# train in Ωₛ and predict in Ωₜ
Ω̂ₜ = Ωₜ |> Learn(Ωₛ, model, feats => label)
	
# actual error of the model
ϵ = mean(loss.(Ωₜ.crop, Ω̂ₜ.crop))
```

## Methods

### Leave-one-out

```@docs
LeaveOneOut
```

### Leave-ball-out

```@docs
LeaveBallOut
```

### K-fold

```@docs
KFoldValidation
```

### Block

```@docs
BlockValidation
```

### Weighted

```@docs
WeightedValidation
```

### Density-ratio

```@docs
DensityRatioValidation
```
