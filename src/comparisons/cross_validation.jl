# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CrossValidation(k, [shuffle])

Compare estimation solvers using k-fold cross-validation.
Optionally shuffle the data (default to true).

    CrossValidation(partitioner)

Compare estimation solvers using cross-validation by
splitting the data with a `partitioner`. This method
is a generalization of k-fold cross-validation, which
uses a [`UniformPartitioner`](@ref) to split the data.

The result of the comparison stores the errors for each
variable of the problem.

## Examples

Compare `solver₁` and `solver₂` on a `problem` with variable
`:var` using 10 folds. Plot error distribution:

```julia
julia> result = compare([solver₁, solver₂], problem, CrossValidation(10))
julia> plot(result, bins=50)
```
"""
struct CrossValidation{P} <: AbstractEstimSolverComparison
  partitioner::P
end

CrossValidation(k::Int, shuffle::Bool) = CrossValidation(UniformPartitioner(k, shuffle))
CrossValidation(k::Int) = CrossValidation(k, true)
CrossValidation() = CrossValidation(10)

"""
    CVResult(errors, solvernames)

Stores the cross-validation errors for each variable of the
problem and the solver names used in the comparison.
"""
struct CVResult
  errors::Dict{Symbol,Vector}
  solvernames::Vector{String}
end

function compare(solvers::AbstractVector{S}, problem::EstimationProblem,
                 cmp::CrossValidation) where {S<:AbstractEstimationSolver}
  # retrieve problem info
  pdata = data(problem)
  pdomain = domain(problem)

  # folds for cross-validation
  folds = subsets(partition(pdata, cmp.partitioner))
  nfolds = length(folds)

  # save results in a dictionary
  errors = Dict{Symbol,Vector}()

  for (var, V) in variables(problem)
    # mappings from data to domain locations
    varmap = Dict(datloc => domloc for (domloc, datloc) in datamap(problem, var))

    # validation errors for each solver
    errors4solver = [Vector{V}() for s in 1:length(solvers)]

    # k-fold validation loop
    for k in 1:nfolds
      # holdout set
      hold = folds[k]

      # training set
      train = [ind for i in vcat(1:k-1, k+1:nfolds) for ind in folds[i]]

      # discard indices that were filtered out by mapping strategy (e.g. missing values)
      hold  = filter(in(keys(varmap)), hold)
      train = filter(in(keys(varmap)), train)

      # skip in case of empty training set
      isempty(train) && continue

      # copy data to correct locations in domain
      mapper = CopyMapper([varmap[ind] for ind in train])

      subproblem = EstimationProblem(view(pdata, train), pdomain, var, mapper=mapper)

      if nworkers() > 1
        # run solvers in parallel
        λ = solver -> solve(subproblem, solver)
        solutions = pmap(λ, solvers)
      else
        # fallback to serial execution
        solutions = [solve(subproblem, solver) for solver in solvers]
      end

      for (s, solution) in enumerate(solutions)
        # get true holdout values
        observations = [value(pdata, loc, var) for loc in hold]

        # get solver estimate at holdout locations
        estimates = [solution.mean[var][varmap[loc]] for loc in hold]

        # save error and continue
        append!(errors4solver[s], estimates - observations)
      end
    end

    push!(errors, var => errors4solver)
  end

  CVResult(errors, [string(s) for s in solvers])
end

@recipe function f(result::CVResult; labels=nothing)
  # retrieve solver names
  solvers = result.solvernames
  nsolvers = length(solvers)

  # provide default names if labels are not specified
  labels == nothing && (labels = solvers)

  for (var, errs) in result.errors
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
