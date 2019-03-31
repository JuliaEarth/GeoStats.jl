@testset "Solvers" begin
  data1D = readgeotable(joinpath(datadir,"data1D.tsv"), delim='\t', coordnames=[:x])
  data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
  grid1D = RegularGrid{Float64}(100)
  grid2D = RegularGrid{Float64}(100,100)

  @testset "Kriging" begin
    problem1D = EstimationProblem(data1D, grid1D, :value)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    global_kriging = Kriging(
      :value => (variogram=GaussianVariogram(range=35.,nugget=0.),)
    )
    nearest_kriging = Kriging(
      :value => (variogram=GaussianVariogram(range=35.,nugget=0.), maxneighbors=3)
    )
    local_kriging = Kriging(
      :value => (variogram=GaussianVariogram(range=35.,nugget=0.),
                 maxneighbors=3, neighborhood=BallNeighborhood(grid2D,100.))
    )

    solvers = [global_kriging, nearest_kriging, local_kriging]
    snames  = ["GlobalKriging", "NearestKriging", "LocalKriging"]

    solutions1D = [solve(problem1D, solver) for solver in solvers]
    solutions2D = [solve(problem2D, solver) for solver in solvers]

    # basic checks
    for solution in solutions2D
      M, V = solution[:value]
      @test M[26,26] == 1.
      @test M[51,76] == 0.
      @test M[76,51] == 1.
    end

    if visualtests
      gr(size=(800,400))
      for i in 1:2
        solution, sname = solutions1D[i], snames[i]
        @plottest plot(solution) joinpath(datadir,sname*"1D.png") !istravis
      end
      for (solution, sname) in zip(solutions2D, snames)
        @plottest contourf(solution) joinpath(datadir,sname*"2D.png") !istravis
      end
    end
  end

  @testset "SeqGaussSim" begin
    nreals = 3

    ###################
    ##  CONDITIONAL  ##
    ###################
    problem1D = SimulationProblem(data1D, grid1D, :value, nreals)
    problem2D = SimulationProblem(data2D, grid2D, :value, nreals)

    nearest_sgs = SeqGaussSim(
      :value => (variogram=GaussianVariogram(range=35.),
                 maxneighbors=3)
     )
    local_sgs = SeqGaussSim(
      :value => (variogram=GaussianVariogram(range=35.),
                 neighborhood=BallNeighborhood(grid2D,10.))
    )

    solvers = [nearest_sgs, local_sgs]
    snames  = ["NearestSGSCond", "LocalSGSCond"]

    Random.seed!(2017)
    solutions2D = [solve(problem2D, solver) for solver in solvers]

    # basic checks
    for solution in solutions2D
      reals = solution[:value]
      @test all(reals[i][26,26] == 1. for i in 1:nreals)
      @test all(reals[i][51,76] == 0. for i in 1:nreals)
      @test all(reals[i][76,51] == 1. for i in 1:nreals)
    end

    if visualtests
      gr(size=(800,400))
      for i in [2]
        solution, sname = solutions2D[i], snames[i]
        @plottest plot(solution) joinpath(datadir,sname*"2D.png") !istravis
      end
    end

    ###################
    ## UNCONDITIONAL ##
    ###################
    problem1D = SimulationProblem(grid1D, :value => Float64, nreals)
    problem2D = SimulationProblem(grid2D, :value => Float64, nreals)

    Random.seed!(2017)
    solution2D = solve(problem2D, local_sgs)

    if visualtests
      gr(size=(800,400))
      @plottest plot(solution2D) joinpath(datadir,"LocalSGSUncond2D.png") !istravis
    end
  end

  @testset "CookieCutter" begin
    problem2D = SimulationProblem(grid2D, Dict(:facies => Int, :property => Float64), 3)

    solver₁ = CookieCutter(Dummy(:facies => NamedTuple()), [0 => Dummy(), 1 => Dummy()])

    γ₀ = GaussianVariogram(distance=Ellipsoidal([30.,10.],[0.]))
    γ₁ = GaussianVariogram(distance=Ellipsoidal([10.,30.],[0.]))
    solver₂ = CookieCutter(Dummy(:facies => NamedTuple()),
                           [0 => SeqGaussSim(:property => (variogram=γ₀,)),
                            1 => SeqGaussSim(:property => (variogram=γ₁,))])

    Random.seed!(1234)
    solution₁ = solve(problem2D, solver₁)
    solution₂ = solve(problem2D, solver₂)

    if visualtests
      gr(size=(800,400))
      @plottest plot(solution₁) joinpath(datadir,"CookieCutter1.png") !istravis
      @plottest plot(solution₂) joinpath(datadir,"CookieCutter2.png") !istravis
    end
  end
end
