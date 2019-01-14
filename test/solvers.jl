@testset "Solvers" begin
  data1D = readgeotable(joinpath(datadir,"data1D.tsv"), delim='\t', coordnames=[:x])
  data2D = readgeotable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
  grid1D = RegularGrid{Float64}(100)
  grid2D = RegularGrid{Float64}(100,100)

  @testset "Kriging" begin
    problem1D = EstimationProblem(data1D, grid1D, :value)
    problem2D = EstimationProblem(data2D, grid2D, :value)

    gsolver = Kriging(
      :value => (variogram=GaussianVariogram(range=35.,nugget=0.),)
    )
    lsolver = Kriging(
      :value => (variogram=GaussianVariogram(range=35.,nugget=0.), maxneighbors=3)
    )

    # solve with global Kriging
    gsol1D = solve(problem1D, gsolver)
    gsol2D = solve(problem2D, gsolver)

    # solve with local Kriging
    lsol1D = solve(problem1D, lsolver)
    lsol2D = solve(problem2D, lsolver)

    # basic checks
    for sol in [gsol2D, lsol2D]
      result = digest(sol)
      @test Set(keys(result)) == Set([:value])
      @test isapprox(result[:value][:mean][26,26], 1., atol=1e-8)
      @test isapprox(result[:value][:mean][51,76], 0., atol=1e-8)
      @test isapprox(result[:value][:mean][76,51], 1., atol=1e-8)
    end

    if visualtests
      gr(size=(800,400))
      refimg1D = joinpath(datadir,"GlobalKriging1D.png")
      refimg2D = joinpath(datadir,"GlobalKriging2D.png")
      @plottest plot(gsol1D) refimg1D !istravis 0.1
      @plottest plot(gsol2D) refimg2D !istravis 0.1

      refimg1D = joinpath(datadir,"LocalKriging1D.png")
      refimg2D = joinpath(datadir,"LocalKriging2D.png")
      @plottest plot(lsol1D) refimg1D !istravis 0.1
      @plottest plot(lsol2D) refimg2D !istravis 0.1
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
        refimg1D = joinpath(datadir,"SGSCond1D.png")
        refimg2D = joinpath(datadir,"SGSCond2D.png")
        # @plottest plot(solution1D) refimg1D !istravis
        # @plottest plot(solution2D) refimg2D !istravis
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
        refimg1D = joinpath(datadir,"SGSUncond1D.png")
        refimg2D = joinpath(datadir,"SGSUncond2D.png")
        # @plottest plot(solution1D) refimg1D !istravis
        # @plottest plot(solution2D) refimg2D !istravis
      end
    end
  end

  @testset "CookieCutter" begin
    problem2D = SimulationProblem(grid2D, Dict(:facies => Int, :property => Float64), 3)

    # TODO: test solution correctness
  end
end
