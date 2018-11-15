@testset "Solvers" begin
  grid1D = RegularGrid{Float64}(100)
  grid2D = RegularGrid{Float64}(100,100)

  @testset "Kriging" begin
    problem1D = EstimationProblem(data1D, grid1D, :value)
    problem2D = EstimationProblem(data2D, grid2D, :value)
    solver = Kriging(:value => (variogram=GaussianVariogram(range=35.),))

    solution1D = solve(problem1D, solver)
    solution2D = solve(problem2D, solver)

    # basic checks
    result = digest(solution2D)
    @test Set(keys(result)) == Set([:value])
    @test isapprox(result[:value][:mean][26,26], 1., atol=1e-8)
    @test isapprox(result[:value][:mean][51,76], 0., atol=1e-8)
    @test isapprox(result[:value][:mean][76,51], 1., atol=1e-8)

    if ismaintainer || istravis
      @testset "Plot recipe" begin
        function plot_solution(fname, solution)
          plot(solution, size=(800,400))
          png(fname)
        end
        plot_sol1D(fname) = plot_solution(fname, solution1D)
        plot_sol2D(fname) = plot_solution(fname, solution2D)
        refimg1D = joinpath(datadir,"KrigingSolution1D.png")
        refimg2D = joinpath(datadir,"KrigingSolution2D.png")
        @test test_images(VisualTest(plot_sol1D, refimg1D), popup=!istravis, tol=0.1) |> success
        @test test_images(VisualTest(plot_sol2D, refimg2D), popup=!istravis, tol=0.1) |> success
      end
    end
  end

  @testset "SeqGaussSim" begin
    @testset "Conditional" begin
      nreals = 3

      problem1D = SimulationProblem(data1D, grid1D, :value, nreals)
      problem2D = SimulationProblem(data2D, grid2D, :value, nreals)
      solver = SeqGaussSim(:value => (variogram=SphericalVariogram(range=35.),))

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

      if ismaintainer || istravis
        @testset "Plot recipe" begin
          function plot_solution(fname, solution)
            plot(solution, size=(1000,300))
            png(fname)
          end
          plot_sol1D(fname) = plot_solution(fname, solution1D)
          plot_sol2D(fname) = plot_solution(fname, solution2D)
          refimg1D = joinpath(datadir,"SeqGaussSimSolution1D.png")
          refimg2D = joinpath(datadir,"SeqGaussSimSolution2D.png")
          # @test test_images(VisualTest(plot_sol1D, refimg1D), popup=!istravis) |> success
          # @test test_images(VisualTest(plot_sol2D, refimg2D), popup=!istravis) |> success
        end
      end
    end

    @testset "Unconditional" begin
      problem1D = SimulationProblem(grid1D, :value => Float64, 1)
      problem2D = SimulationProblem(grid2D, :value => Float64, 1)
      solver = SeqGaussSim(:value => (variogram=GaussianVariogram(range=35.),))

      #solution2D = solve(problem2D, SeqGaussSim())
      # TODO: test solution correctness
    end
  end

  @testset "CookieCutter" begin
    problem2D = SimulationProblem(grid2D, Dict(:facies => Int, :property => Float64), 3)

    # TODO: test solution correctness
  end
end
