@testset "Mappers" begin
  @testset "SimpleMapper" begin
    @testset "RegularGrid" begin
      grid1D = RegularGrid{Float64}(100)
      mappings = map(data1D, grid1D, [:value], SimpleMapper())
      @test mappings[:value] == Dict(100=>11,81=>9,11=>2,21=>3,91=>10,51=>6,61=>7,71=>8,31=>4,41=>5,1=>1)

      grid2D = RegularGrid{Float64}(100,100)
      mappings = map(data2D, grid2D, [:value], SimpleMapper())
      @test mappings[:value] == Dict(5076=>3,2526=>1,7551=>2)
    end
    @testset "PointSet" begin
      pc2D = PointSet([25. 50. 75.; 25. 75. 50.])
      mappings = map(data2D, pc2D, [:value], SimpleMapper())
      @test mappings[:value] == Dict(2=>2,3=>3,1=>1)
    end
  end
end
