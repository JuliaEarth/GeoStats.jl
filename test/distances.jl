@testset "Distances" begin
  d₁ = Ellipsoidal([1.,1.], [0.])
  d₂ = Ellipsoidal([1.,2.], [0.])
  @test evaluate(d₁, [1.,0.], [0.,0.]) == evaluate(d₁, [0.,1.], [0.,0.])
  @test evaluate(d₂, [1.,0.], [0.,0.]) != evaluate(d₂, [0.,1.], [0.,0.])

  d₃ = Ellipsoidal([1.,.5,.5], [π/4,0.,0.])
  @test evaluate(d₃, [1.,1.,0.], [0.,0.,0.]) ≈ √2
  @test evaluate(d₃, [-1.,1.,0.], [0.,0.,0.]) ≈ √8
end
