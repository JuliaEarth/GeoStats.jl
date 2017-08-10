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
    AbstractPath

A path on a spatial domain of type `D`.
"""
abstract type AbstractPath{D<:AbstractDomain} end

"""
    Base.start(path)

Return the start of the `path`.
"""
Base.start(::AbstractPath{D}) where {D<:AbstractDomain} = error("not implemented")

"""
    Base.next(path, state)

Advance in the `path` from current `state`.
"""
Base.next(::AbstractPath{D}, state) where {D<:AbstractDomain} = error("not implemented")

"""
    Base.done(path, state)

Return true if `state` is the end of the `path`.
"""
Base.done(::AbstractPath{D}, state) where {D<:AbstractDomain} = error("not implemented")

"""
    Base.length(path)

Return the length of a `path`.
"""
Base.length(p::AbstractPath{D}) where {D<:AbstractDomain} = npoints(p.domain)

#------------------
# IMPLEMENTATIONS
#------------------
"""
    SimplePath(domain)

A simple (or default) path on a spatial `domain`.
"""
struct SimplePath{D<:AbstractDomain} <: AbstractPath{D}
  domain::D
end
SimplePath(domain) = SimplePath{typeof(domain)}(domain)
Base.start(p::SimplePath)       = 1
Base.next(p::SimplePath, state) = state, state + 1
Base.done(p::SimplePath, state) = state == npoints(p.domain) + 1

"""
    RandomPath(domain)

A random path on a spatial `domain`.
"""
struct RandomPath{D<:AbstractDomain} <: AbstractPath{D}
  domain::D
  permut::Vector{Int}

  function RandomPath{D}(domain, permut) where {D<:AbstractDomain}
    @assert length(permut) == npoints(domain) "incorrect dimension"
    new(domain, permut)
  end
end
RandomPath(domain) = RandomPath{typeof(domain)}(domain, randperm(npoints(domain)))
Base.start(p::RandomPath)       = Base.start(p.permut)
Base.next(p::RandomPath, state) = Base.next(p.permut, state)
Base.done(p::RandomPath, state) = Base.done(p.permut, state)
