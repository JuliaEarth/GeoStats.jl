# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CrossValidation(k, shuffle)

Compare estimation solvers using k-fold cross validation.

The result of the comparison stores the errors for each
variable of the problem.

## Parameters

* k       - number of folds for cross-validation
* shuffle - whether or not to shuffle the data

## Examples

Compare `solver₁` and `solver₂` on a `problem` with variable
`:var` using 10 folds. Plot error distribution:

```julia
julia> result = compare([solver₁, solver₂], problem, CrossValidation(10))
julia> plot(result, bins=50)
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

"""
    CrossValidationResult(errors, solvernames)

Stores the cross-validation errors for each variable of the
problem and the solver names used in the comparison.
"""
struct CrossValidationResult
  errors4var::Dict{Symbol,Vector}
  solvernames::Vector{String}
end

function compare(solvers::AbstractVector{S}, problem::EstimationProblem,
                 cmp::CrossValidation) where {S<:AbstractEstimationSolver}
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)
  pmapper = mapper(problem)

  nfolds = cmp.k

  # save results in a dictionary
  errors4var = Dict{Symbol,Vector}()

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

      subproblem = EstimationProblem(view(pdata, train), pdomain, var, mapper=pmapper)

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

    push!(errors4var, var => errors)
  end

  CrossValidationResult(errors4var, [string(s) for s in solvers])
end

@recipe function f(result::CrossValidationResult; labels=nothing)
  # retrieve solver names
  solvers = result.solvernames
  nsolvers = length(solvers)

  # provide default names if labels are not specified
  labels == nothing && (labels = solvers)

  for (var, errs) in result.errors4var
    layout := (nsolvers, 1)
    link := :x
    for (s, err) in enumerate(errs)
      @series begin
        subplot := s
        seriestype := :histogram
        label := labels[s]
        seriescolor --> :black
        fillalpha --> 0.7
        linecolor --> :white
        err
      end
      @series begin
        subplot := s
        seriestype := :vline
        label := "mean error"
        linecolor := :green
        linestyle := :dash
        linewidth := 2
        [sum(err)/length(err)]
      end
      @series begin
        subplot := s
        seriestype := :vline
        label := "interquartile"
        linecolor := :orange
        linestyle := :dot
        linewidth := 2
        quantile(err, [.25,.75])
      end
      xlabel --> "errors = estimates - observations"
      ylabel --> "histogram"
    end
  end
end
