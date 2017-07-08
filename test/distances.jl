@testset "Distance functions" begin
  # basic distance properties
  a, b, c = rand(2), rand(2), rand(2)
  for d in [EuclideanDistance(),
            EllipsoidDistance([1.,.5],[π/4]),
            HaversineDistance()]
    # positiveness
    @test d(a, b) ≥ 0.
    @test d(a, a) ≈ 0.

    # symmetry
    @test d(a, b) ≈ d(b, a)

    # triangle inequality
    @test d(a, c) ≤ d(a, b) + d(b, c)
  end

  # Euclidean distance
  d = EuclideanDistance()
  @test d([1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test d([-1.,1.,0.], [0.,0.,0.]) ≈ √2

  # ellipsoid distance
  d = EllipsoidDistance([1.,.5,.5], [π/4,0.,0.])
  @test d([1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test d([-1.,1.,0.], [0.,0.,0.]) ≈ √8

  # haversine distance
  d = HaversineDistance()
  hoover_tower = [37.427698, -122.166977] # Hoover tower, Stanford
  sather_tower = [37.872197, -122.257834] # Sather tower, Berkeley
  @test d(hoover_tower, sather_tower) < 60.
end
