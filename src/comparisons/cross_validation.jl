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
    CrossValidation(k, shuffle)

Compare estimation solvers using k-fold cross validation.

The result of the comparison is a dictionary mapping each
variable of the problem to a vector of validation errors
for each solver being compared.

## Parameters

* k       - number of folds for cross-validation
* shuffle - whether or not to shuffle the data

## Examples

Compare `solver₁` and `solver₂` on a `problem` with variable
`:var` using 10 folds. Plot error distribution:

```julia
julia> results = compare([solver₁, solver₂], problem, CrossValidation(10))

julia> plt₁ = histogram(results[:var][1], label="solver₁")
julia> plt₂ = histogram(results[:var][2], label="solver₂")

julia> plot(plt₁, plt₂, title="Error distribution for each solver")
```

Select solver with smallest absolute mean validation error:

```julia
julia> mean_err₁ = abs(mean(results[:var][1]))
julia> mean_err₂ = abs(mean(results[:var][2]))

julia> solver = mean_err₁ < mean_err₂ ? solver₁ : solver₂
```
"""
struct CrossValidation <: AbstractEstimSolverComparison
  k::Int
  shuffle::Bool

  function CrossValidation(k::Int, shuffle::Bool)
    @assert k > 1 "number of folds must be greater than 1"
    new(k, shuffle)
  end
end

CrossValidation(k) = CrossValidation(k, true)
CrossValidation() = CrossValidation(10)

function compare(solvers::AbstractVector{S}, problem::EstimationProblem,
                 cmp::CrossValidation) where {S<:AbstractEstimationSolver}
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  nfolds = cmp.k

  # save results in a dictionary
  results = Dict{Symbol,Vector}()

  for (var,V) in variables(problem)
    # mappings from domain to data locations
    varmap = datamap(problem, var)
    domlocs = collect(keys(varmap))
    datlocs = collect(values(varmap))

    # number of points for variable
    npts = length(varmap)

    # points per fold
    m = npts ÷ nfolds

    @assert nfolds ≤ npts "number of folds must be smaller or equal to number of points"

    # shuffle points if necessary
    perm = cmp.shuffle ? shuffle(1:npts) : sortperm(datlocs)
    domlocs = domlocs[perm]
    datlocs = datlocs[perm]

    # validation errors for each solver
    errors = [V[] for s in 1:length(solvers)]

    # k-fold validation loop
    for i in 0:nfolds-1
      iₛ, iₑ = i*m + 1, (i+1)*m

      # holdout set
      domhold = domlocs[iₛ:iₑ]
      dathold = datlocs[iₛ:iₑ]

      # training set
      train = vcat(datlocs[1:iₛ-1], datlocs[iₑ+1:end])

      subproblem = EstimationProblem(view(pdata, train), pdomain, var)

      if nworkers() > 1
        # run solvers in parallel
        λ = solver -> solve(subproblem, solver)
        solutions = pmap(λ, solvers)
      else
        # fallback to serial execution
        solutions = [solve(subproblem, solver) for solver in solvers]
      end

      for (s, solution) in enumerate(solutions)
        # get solver estimates at holdout locations
        estimates = [solution.mean[var][j] for j in domhold]

        # get true holdout values
        observations = [value(pdata, j, var) for j in dathold]

        # save error and continue
        append!(errors[s], estimates - observations)
      end
    end

    push!(results, var => errors)
  end

  results
end
