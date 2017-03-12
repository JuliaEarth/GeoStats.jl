GeoStats.jl
===========

*Geostatistics in Julia.*

[![Build Status](https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master)](https://travis-ci.org/juliohm/GeoStats.jl)
[![GeoStats](http://pkg.julialang.org/badges/GeoStats_0.5.svg)](http://pkg.julialang.org/?pkg=GeoStats)
[![Coverage Status](https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/GeoStats.jl)

Introduction
------------

This project provides efficient geostatistical methods for the Julia programming language. It is in its initial development, and currently only implements Kriging estimation methods. More features will be added as the Julia type system matures.

Installation
------------

Get the latest stable release with Julia's package manager:

```julia
Pkg.add("GeoStats")
```

Algorithms
----------

### Estimation

Method | Function
:-----:|:--------:
Simple Kriging | `kriging`
Ordinary Kriging | `kriging`
Universal Kriging | `unikrig`

Documentation
-------------

Below is a short example of usage:

```julia
using GeoStats

# create some data
dim, nobs = 3, 10
X = rand(dim, nobs); z = rand(nobs)

# target location
xₒ = rand(dim)

# define a covariance model
cov = GaussianCovariance(0.,1.,1.) # nugget, sill and range

# define an estimator (i.e. build the Kriging system)
simkrig = SimpleKriging(X, z, cov, mean(z))
ordkrig = OrdinaryKriging(X, z, cov)
unikrig = UniversalKriging(X, z, cov, 1)

# estimate at target location
μ, σ² = estimate(simkrig, xₒ)
μ, σ² = estimate(ordkrig, xₒ)
μ, σ² = estimate(unikrig, xₒ)
```

Contributing
------------

Contributions are very welcome, as a feature requests and suggestions.

Please [open an issue](https://github.com/juliohm/GeoStats.jl/issues) if you encounter any problems.
