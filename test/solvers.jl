@testset "Solvers" begin
  grid = RegularGrid{Float64}(100,100)

  @testset "Kriging solver" begin
    problem = EstimationProblem(data2D, grid, :value)
    solver = Kriging(:value => @NT(variogram=GaussianVariogram(range=20.)))

    solution = solve(problem, solver)

    # basic checks
    result = digest(solution)
    @test Set(keys(result)) == Set([:value])

    if ismaintainer || istravis
      @testset "Plot recipe" begin
        function plot_solution(fname)
          plot(solution, size=(800,400))
          png(fname)
        end
        refimg = joinpath(datadir,"KrigingSolution.png")
        @test test_images(VisualTest(plot_solution, refimg), popup=!istravis) |> success
      end
    end
  end

  @testset "SeqGaussSim solver" begin
    # conditional simulation with SeqGaussSim
    problem = SimulationProblem(data2D, grid, :value, 1)
    solution = solve(problem, SeqGaussSim())
    # TODO: test solution correctness

    # unconditional simulation with SeqGaussSim
    problem = SimulationProblem(grid, :value, 1)
    solution = solve(problem, SeqGaussSim())
    # TODO: test solution correctness
  end
end
