using Luxor, Contour, Images

function geostats(s)
  Δ = s / 500 # scale factor, original design was 500units
  circle(O, 245Δ, :clip)
  sethue("white")
  circle(O, 245Δ, :fill)

  # generate contours from image
  pwd()
  i = load("contours.png")
  img = imresize(i, ratio=1.75)
  H, W = size(img)
  imgg = imfilter(img, Kernel.gaussian(15))
  x = (-W / 2.0):(W / 2.0 - 1)  # W elements
  y = (-H / 2.0):(H / 2.0 - 1)  # H elements
  z = Float64.(Gray.(imgg))
  # just two contours required
  clevels = Contour.contourlevels(z, 2)
  contourlines = contours(x, y, z, clevels)

  # draw the contours
  @layer begin
    scale(Δ)
    setline(8Δ)
    for (n, cl) in enumerate(levels(contourlines))
      for l in lines(cl)
        # convert contour points to Luxor coords
        sethue("black")
        pgon = map(p -> Point(p[2], p[1]), zip(coordinates(l)...))
        poly(pgon, :stroke)

        # optional coloring?
        setgray([0.6, 0.8][n])
        poly(pgon, :fill, close=true)
      end
    end
  end

  clipreset()

  sethue("black")
  setline(8Δ)
  circle(O, 245Δ, :stroke)

  sethue(Luxor.julia_purple)
  circle(Point(190, 120)Δ, 55Δ, :fill)

  sethue(Luxor.julia_green)
  circle(Point(70, -55)Δ, 50Δ, :fill)

  sethue(Luxor.julia_red)
  circle(Point(-180, 12)Δ, 40Δ, :fill)
end

function logo(s, fname)
  Drawing(s, s, fname)
  origin()
  geostats(s)
  finish()
  preview()
end

function logotext(w, h, fname)
  Drawing(w, h, fname)
  #background("white")
  origin()
  table = Table([h], [h, w - h])
  @layer begin
    translate(table[2])
    background("white") # comment for transparent background
    sethue("black")
    # find all fonts available on Linux with `fc-list | -f 2 -d ":"`
    fontface("Julius Sans One")
    fontsize(h / 2.5)
    text("GeoStats.jl", halign=:center, valign=:middle)
  end
  @layer begin
    translate(table[1])
    geostats(h)
  end
  finish()
  preview()
end

for ext in [".svg", ".png"]
  logo(120, "../assets/logo" * ext)
  logotext(350, 100, "../assets/logo-text" * ext)
end
