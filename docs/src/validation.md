# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous comparison
of different geostatistical models in the literature. As a user of geostatistics,
you may be interested in trying various models on a given data set to pick the
one with best performance. As a researcher in the field, you may be interested in
benchmarking your new model against other established models.

Errors of geostatistical solvers can be estimated with the [`cverror`](@ref) function:

```@docs
cverror
```

For example, we can perform block cross-validation on a decision tree model using
the following code:

```@example error
using GeoStats
using GeoIO

# load geospatial data
Ω = GeoIO.load("data/agriculture.csv", coords = ("x", "y"))

# 20%/80% split along the (1, -1) direction
Ωₛ, Ωₜ = geosplit(Ω, 0.2, (1.0, -1.0))

# features and label for supervised learning
feats = [:band1,:band2,:band3,:band4]
label = :crop

# learning model
model = DecisionTreeClassifier()

# loss function
loss = MisclassLoss()

# block cross-validation with r = 30.
bcv = BlockValidation(30., loss = Dict(:crop => loss))

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

Below is the list of currently implemented validation methods.

## Leave-one-out

```@docs
LeaveOneOut
```

## Leave-ball-out

```@docs
LeaveBallOut
```

## K-fold

```@docs
KFoldValidation
```

## Block

```@docs
BlockValidation
```

## Weighted

```@docs
WeightedValidation
```

## Density-ratio

```@docs
DensityRatioValidation
```
