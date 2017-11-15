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
    AbstractSolverComparison

A method for comparing geostatistical solvers.
"""
abstract type AbstractSolverComparison end

"""
    AbstractEstimSolverComparison

A method for comparing estimation solvers.
"""
abstract type AbstractEstimSolverComparison <: AbstractSolverComparison end

"""
    AbstractSimSolverComparison

A method for comparing simulation solvers.
"""
abstract type AbstractSimSolverComparison <: AbstractSolverComparison end

"""
    compare(solvers, problem, method)

Compare `solvers` on a given `problem` using a comparison `method`.
"""
compare(::AbstractVector{S}, ::AbstractProblem,
        ::AbstractSolverComparison) where {S<:AbstractSolver} = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("comparisons/visual_comparison.jl")
