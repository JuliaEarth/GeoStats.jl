# Validation

GeoStats.jl was designed to, among other things, facilitate rigorous comparison
of different geostatistical solvers in the literature. As a user of geostatistics,
you may be interested in trying various solvers on a given data set to pick the
one with best performance. As a researcher in the field, you may be interested in
benchmarking your new solver against other established solvers.

Errors of geostatistical solvers can be estimated with the [`error`](@ref) function:

```@docs
error(::Any, ::Any, ::ErrorEstimationMethod)
```

For example, we can perform block cross-validation in a geostatistical learning problem
to estimate the generalization error of the [`PointwiseLearn`](@ref) solver. First, we
define the problem:

```@example error
using GeoStats
using CSV

# load geospatial data
data = georef(CSV.File("data/agriculture.csv"), (:x, :y))

# 20%/80% split along the (1, -1) direction
Ωₛ, Ωₜ = geosplit(Ω, 0.2, (1.0, -1.0))

# features and label for supervised learning
feats = [:band1,:band2,:band3,:band4]
label = :crop

# classiication learning task
𝒯 = ClassificationTask(feats, label)

# geostatistical learning problem
𝒫 = LearningProblem(Ωₛ, Ωₜ, 𝒯)
```

Second, we define the learning solver:

```@example error
# learning model
model = DecisionTreeClassifier()
	
# learning strategy
𝒮 = PointwiseLearn(model)
```

Finally, we define the validation method and estimate the error:

```@example error
# loss function
ℒ = MisclassLoss()

# block cross-validation with r = 30.
ℬ = BlockValidation(30., loss = Dict(:crop => ℒ))

# estimate of generalization error
ϵ̂ = error(𝒮, 𝒫, ℬ)
```

We can unhide the labels in the target domain and compute the actual
error for comparison:

```@example error
# train in Ωₛ and predict in Ωₜ
Ω̂ₜ = solve(𝒫, 𝒮)
	
# actual error of the model
ϵ = mean(ℒ.(Ωₜ.crop, Ω̂ₜ.crop))
```

Below is the list of currently implemented error estimation methods.

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
