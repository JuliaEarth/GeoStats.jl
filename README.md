GeoStats.jl
===========

Geostatistics in [Julia](http://julialang.org).

[![Build Status](https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master)](https://travis-ci.org/juliohm/GeoStats.jl)
[![GeoStats](http://pkg.julialang.org/badges/GeoStats_0.5.svg)](http://pkg.julialang.org/?pkg=GeoStats)
[![Coverage Status](https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/GeoStats.jl)

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

You are encouraged to contribute. If you have questions or suggestions, please [open an issue](https://github.com/juliohm/GeoStats.jl/issues).

### TODO

- [ ] Sequential simulation methods
