@testset "Domains" begin
  @testset "RegularGrid" begin
    grid1 = RegularGrid{Float32}(200,100)
    @test ndims(grid1) == 2
    @test coordtype(grid1) == Float32
    @test size(grid1) == (200,100)
    @test npoints(grid1) == 200*100
    @test coordinates(grid1, 1) == [0.,0.]

    grid2 = RegularGrid([200,100,50], zeros(3), ones(3))
    @test ndims(grid2) == 3
    @test coordtype(grid2) == Float64
    @test size(grid2) == (200,100,50)
    @test npoints(grid2) == 200*100*50
    @test coordinates(grid2, 1) == [0.,0.,0.]

    grid3 = RegularGrid{Float64}(100,200)
    @test sprint(show, grid3) == "100×200 RegularGrid{Float64,2}"
    @test sprint(show, MIME"text/plain"(), grid3) == "RegularGrid{Float64,2}\n  dimensions: (100, 200)\n  origin:     (0.0, 0.0)\n  spacing:    (1.0, 1.0)"
  end
end
