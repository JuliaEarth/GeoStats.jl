# Learning

```@example learning
using GeoStats # hide
import CairoMakie as Mke # hide
```

## Overview

We formalized the concept of *geostatistical learning* in
*Hoffimann et al. 2021.* [Geostatistical Learning: Challenges and Opportunities](https://www.frontiersin.org/articles/10.3389/fams.2021.689393/full).
The main difference compared to classical learning theory lies in the underlying assumptions used to derive learning models.

```@raw html
<p align="center">
<iframe style="width:560px;height:315px" src="https://www.youtube.com/embed/75A6zyn5pIE" title="Geostatistical Learning" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>
```

We provide the [`Learn`](@ref) transform for supervised learning with geospatial data,
and support various learning models written in native Julia. Besides the models listed
below, we support all models from the [ScikitLearn.jl](https://github.com/cstjean/ScikitLearn.jl)
and [MLJ.jl](https://github.com/JuliaAI/MLJ.jl) packages.

```@docs
Learn
```

!!! note

    We highly recommend the native Julia models listed below for maximum performance
    and reproducibility. The integration with external models from ScikiLearn.jl
    requires a local Python installation, which can be hard to reproduce across
    different machines.

For model validation, including cross-validation error estimates, please check the
[Validation](validation.md) section.

## Models

### Nearest neighbor models

```@docs
KNNClassifier
KNNRegressor
```

### Generalized linear models

```@docs
LinearRegressor
GeneralizedLinearRegressor
```

### Decision tree models

```@docs
DecisionTreeClassifier
DecisionTreeRegressor
DecisionTree.impurity_importance
```

### Random forest models

```@docs
RandomForestClassifier
RandomForestRegressor
```

### Adaptive boosting models

```@docs
AdaBoostStumpClassifier
```
