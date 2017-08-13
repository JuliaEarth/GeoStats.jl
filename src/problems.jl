## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
    AbstractProblem

A generic problem in geostatistics.
"""
abstract type AbstractProblem end

"""
    data(problem)

Return the spatial data of the `problem`.
"""
data(problem::AbstractProblem) = problem.geodata

"""
    domain(problem)

Return the spatial domain of the `problem`.
"""
domain(problem::AbstractProblem) = problem.domain

"""
    variables(problem)

Return the target variables of the `problem`.
"""
variables(problem::AbstractProblem) = problem.targetvars

"""
    hasdata(problem)

Return `true` if `problem` has data.
"""
hasdata(problem::AbstractProblem) = npoints(problem.geodata) > 0

"""
    AbstractSolution

A generic solution to a problem in geostatistics.
"""
abstract type AbstractSolution end

#------------------
# IMPLEMENTATIONS
#------------------
include("problems/estimation_problem.jl")
include("problems/simulation_problem.jl")
