GeoStats.jl
===========

Geostatistics in [Julia](http://julialang.org).

[![Build Status](https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master)](https://travis-ci.org/juliohm/GeoStats.jl)
[![GeoStats](http://pkg.julialang.org/badges/GeoStats_0.4.svg)](http://pkg.julialang.org/?pkg=GeoStats&ver=0.4)
[![Coverage Status](https://coveralls.io/repos/juliohm/GeoStats.jl/badge.svg?branch=master)](https://coveralls.io/r/juliohm/GeoStats.jl?branch=master)

Installation
------------

```julia
Pkg.add("GeoStats")
```

Optionally run the test suite with:

```julia
Pkg.test("GeoStats")
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

You are encouraged to contribute patches and ideas. If you have questions or suggestions, please [open an issue](https://github.com/juliohm/GeoStats.jl/issues).
