GeoStats.jl
===========

*Geostatistics in Julia.*

[![Build Status](https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master)](https://travis-ci.org/juliohm/GeoStats.jl)
[![GeoStats](http://pkg.julialang.org/badges/GeoStats_0.5.svg)](http://pkg.julialang.org/?pkg=GeoStats)
[![Coverage Status](https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/GeoStats.jl)

Introduction
------------

This project provides efficient geostatistical methods for the Julia programming language. It is in its initial development, and as such only contains Kriging estimation methods. More features will be added as the Julia type system matures.

Installation
------------

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

The library is well documented. Type `?` in the Julia prompt followed by the name of the function (e.g. kriging) for help.

Contributing
------------

Contributions are very welcome, as a feature requests and suggestions.

Please [open an issue](https://github.com/juliohm/GeoStats.jl/issues) if you encounter any problems.
