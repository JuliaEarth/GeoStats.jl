@testset "Paths" begin
  grid = RegularGrid{Float64}(100,100)

  # make sure iteration works
  for path in [GeoStats.SimplePath(grid),
               GeoStats.RandomPath(grid)]
    count = 0
    for location in path
      count += 1
    end
    @test count == length(path)
  end
end
