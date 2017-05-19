using Luxor

srand(2017)

# Julia colors
darker_purple = (0.584, 0.345, 0.698)
lighter_purple  = (0.667, 0.475, 0.757)
darker_green  = (0.22, 0.596, 0.149)
lighter_green  = (0.376, 0.678, 0.318)
darker_red  = (0.796, 0.235, 0.2)
lighter_red  = (0.835, 0.388, 0.361)

purples = (darker_purple, lighter_purple)
greens = (darker_green, lighter_green)
reds = (darker_red, lighter_red)

# Logo size
w = 800; h = 250
Drawing(w, h, "GeoStats.png")

# Draw axes
oᵥ = 10; oₕ = 30
translate(Point(oᵥ,oₕ))
axes()

# Draw random points
for i=1:200
    color = rand([purples, greens, reds])
    pos = Point(rand(10:w),rand(10:h))
    radius = 5
    sethue(color[1]); circle(pos, .65*radius, :fill)
    sethue(color[2]); circle(pos, .75*radius, :stroke)
end

# Draw GeoStats.jl
origin()
translate(oᵥ, oₕ)
sethue("black")
fontsize(120); fontface("Georgia-Bold")
text("GeoStats.jl", halign=:center, valign=:middle)

# Save image to disk
finish()
