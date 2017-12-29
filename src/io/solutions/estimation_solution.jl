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
    save(file, solution)

Save estimation `solution` to GSLIB `file`.
"""
function save(file::File{format"GSLIB"}, solution::EstimationSolution{<:RegularGrid})
  # retrieve grid info
  gsize = size(solution.domain)
  gorig = origin(solution.domain)
  gspac = spacing(solution.domain)

  # reshape to 3D if necessary
  if length(gsize) == 2
    gsize = (gsize...,1)
    gorig = (gorig...,0.)
    gspac = (gspac...,0.)
  end
  if length(gsize) == 1
    gsize = (gsize...,1,1)
    gorig = (gorig...,0.,0.)
    gspac = (gspac...,0.,0.)
  end

  @assert length(gsize) == 3 "grid size not supported"

  vars = sort(collect(keys(solution.mean)))

  propnames = String[]
  properties = Vector{Float64}[]
  for var in vars
    property₁ = solution.mean[var]
    property₂ = solution.variance[var]
    propname₁ = "$(var)_mean"
    propname₂ = "$(var)_variance"

    append!(properties, [property₁, property₂])
    append!(propnames,  [propname₁, propname₂])
  end

  save(file, properties, gsize, origin=gorig, spacing=gspac, propnames=propnames)
end
