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
      result = digest(solution)
      @test Set(keys(result)) == Set([:value])
      @test result[:value][:mean][26,26] == 1.
      @test result[:value][:mean][51,76] == 0.
      @test result[:value][:mean][76,51] == 1.
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
    @testset "Conditional" begin
      problem1D = SimulationProblem(data1D, grid1D, :value, nreals)
      problem2D = SimulationProblem(data2D, grid2D, :value, nreals)

      solver = SeqGaussSim(:value => (variogram=GaussianVariogram(range=35.),))

      Random.seed!(2017)
      solution1D = solve(problem1D, solver)
      solution2D = solve(problem2D, solver)

      # basic checks
      result = digest(solution2D)
      @test Set(keys(result)) == Set([:value])
      for i=1:nreals
        @test result[:value][i][26,26] == 1.
        @test result[:value][i][51,76] == 0.
        @test result[:value][i][76,51] == 1.
      end

      if visualtests
        gr(size=(1000,300))
        # @plottest plot(solution1D) joinpath(datadir,"SGSCond1D.png") !istravis
        # @plottest plot(solution2D) joinpath(datadir,"SGSCond2D.png") !istravis
      end
    end

    @testset "Unconditional" begin
      problem1D = SimulationProblem(grid1D, :value => Float64, nreals)
      problem2D = SimulationProblem(grid2D, :value => Float64, nreals)

      solver = SeqGaussSim(:value => (variogram=GaussianVariogram(range=35.),))

      Random.seed!(2017)
      solution1D = solve(problem1D, solver)
      solution2D = solve(problem2D, solver)

      if visualtests
        gr(size=(1000,300))
        # @plottest plot(solution1D) joinpath(datadir,"SGSUncond1D.png") !istravis
        # @plottest plot(solution2D) joinpath(datadir,"SGSUncond2D.png") !istravis
      end
    end
  end

  @testset "CookieCutter" begin
    problem2D = SimulationProblem(grid2D, Dict(:facies => Int, :property => Float64), 3)

    # TODO: test solution correctness
  end
end
