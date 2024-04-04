# Tips and Hints for Beginners!

I started using GeoStats with a very simple workflow in mind but little
experience with julia. I could get to grips with most concepts at a high
level but, when implementing the nitty-gritty of data manipulation, I was
lost. The kind of details that more experienced users take for granted
held me up.

For most users of GeoStats, this this section on tips and hints will be completely unnecessary. However, if, like me, you are new
and inexperienced, it might save you some time. 
## Working with a GeoTable

### Reading a file

Reading a shapefile with `GeoIO` is very easy and will result in a GeoTable.
This consists of a tabular set of data columns very similar to those in a regular DataFrame (the `value`s) together with a special column containing the
geometry data (the `domain`) from the shape file.

For example, reading the shapefile of Local Authority Boundaries in the UK (available
from the [Office for National Statistics](https://geoportal.statistics.gov.uk/datasets/127c4bda06314409a1fa0df505f510e6_0/explore))

```
julia> gt = GeoIO.load("LAD_DEC_2023_UK_BFC.shp")
```
produces the following:
```
┌─────────────┬─────────────────────────────┬─────────────┬─────────────┬─────────────┬────────────┬────────────┬──────────────────────────────────────┬───────────────────┐
│   LAD23CD   │           LAD23NM           │  LAD23NMW   │    BNG_E    │    BNG_N    │    LONG    │    LAT     │               GlobalID               │     geometry      │
│ Categorical │         Categorical         │ Categorical │ Categorical │ Categorical │ Continuous │ Continuous │             Categorical              │   MultiPolygon    │
│  [NoUnits]  │          [NoUnits]          │  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │ [NoUnits]  │ [NoUnits]  │              [NoUnits]               │                   │
├─────────────┼─────────────────────────────┼─────────────┼─────────────┼─────────────┼────────────┼────────────┼──────────────────────────────────────┼───────────────────┤
│  E06000001  │         Hartlepool          │   missing   │   447160    │   531474    │  -1.27018  │  54.6761   │ ed77cf59-0f99-40ee-8ce0-3c495b0436dd │ Multi(2×PolyArea) │
│  E06000002  │        Middlesbrough        │   missing   │   451141    │   516887    │  -1.21099  │  54.5447   │ 12aebc50-49df-4d0f-af2e-7b18e5928ad7 │ Multi(4×PolyArea) │
│  E06000003  │    Redcar and Cleveland     │   missing   │   464361    │   519597    │  -1.00608  │  54.5675   │ b073197d-76d1-468b-a1ca-e71a9465fc1e │ Multi(3×PolyArea) │
│  E06000004  │      Stockton-on-Tees       │   missing   │   444940    │   518179    │  -1.30664  │  54.5569   │ a722dfde-1ff3-4a0c-90e7-4b7cc413ba49 │ Multi(6×PolyArea) │
│  E06000005  │         Darlington          │   missing   │   428029    │   515648    │  -1.56835  │  54.5353   │ 7341c0fb-23f7-4180-9f8f-f11c67107389 │ Multi(1×PolyArea) │
│  E06000006  │           Halton            │   missing   │   354246    │   382146    │  -2.68853  │  53.3342   │ fbd4f0f4-0d8c-4f38-8abf-6804e84c4ace │ Multi(2×PolyArea) │
│  E06000007  │         Warrington          │   missing   │   362744    │   388457    │  -2.56167  │  53.3916   │ bb0be773-54c4-4af5-9446-b9378094e644 │ Multi(1×PolyArea) │
│  E06000008  │    Blackburn with Darwen    │   missing   │   369489    │   422806    │  -2.46361  │  53.7008   │ 6bd5145d-d596-4f62-b43e-8b526829bd61 │ Multi(1×PolyArea) │
│  E06000009  │          Blackpool          │   missing   │   332819    │   436635    │  -3.02199  │  53.8216   │ 04541f38-9b18-4360-8ec1-c01f8eeb39ec │ Multi(1×PolyArea) │
│      ⋮      │              ⋮              │      ⋮      │      ⋮      │      ⋮      │     ⋮      │     ⋮      │                  ⋮                   │         ⋮         │
└─────────────┴─────────────────────────────┴─────────────┴─────────────┴─────────────┴────────────┴────────────┴──────────────────────────────────────┴───────────────────┘
                                                                                                                                                            352 rows omitted
```
which has 8 columns of data values and a geometry column.

The final column in the table contains the geometry needed, for example, to produce a map. It is a special column and,
unlike the other, simple data columns, contains some clever complexity.

### Accessing the geometry data

We can look inside this geometry column to see how it is made up. For example, the first row here is for Hartlepool.

```julia
julia> gt.geometry[1]
MultiPolyArea{2,Float64}
├─ PolyArea((4.50155e5, 5.25938e5), ..., (4.5014e5, 5.25925e5))
└─ PolyArea((4.47214e5, 5.37036e5), ..., (4.47229e5, 5.37033e5))
```
But each PolyArea is made of vertices:
```
vertices(gt.geometry[1])
6634-element Vector{Point2}:
 Point(450154.59949999955, 525938.2011999991)
 Point(450156.80090000015, 525940.2006000001)
 Point(450164.26499999966, 525944.7221000008)
 Point(450158.0, 525944.1999999993)
 Point(450150.0, 525938.8000000007)
 Point(450143.0, 525930.3000000007)
 Point(450140.3121999996, 525924.8535999991)
 ⋮
 Point(447263.60080000013, 537113.8022000007)
 Point(447259.09889999963, 537108.8036000002)
 Point(447255.9988000002, 537102.1954999994)
 Point(447246.0965, 537052.5997000001)
 Point(447243.20249999966, 537047.6011999995)
 Point(447233.6958999997, 537035.1046999991)
 Point(447228.7982999999, 537033.3951999992)
 ```
 and we can extract the coordinates of the first vertex point by:
 ```julia
coordinates(vertices(gt.geometry[1])[1])
Vec(450154.59949999955, 525938.2011999991)
```
And just the x-coordinate:
```julia
coordinates(vertices(gt.geometry[1])[1])[1]
450154.59949999955
```
To find the maximum x- and y- coordinate values in the whole dataset, for example, we could do the following:
```
julia> function metrominmax(gt)
          let minx, maxx, miny, maxy
              for borough = 1:length(gt.geometry)
                  ry = extrema([coordinates(point)[2] for point in vertices(gt.geometry[borough])])
                  rx = extrema([coordinates(point)[1] for point in vertices(gt.geometry[borough])])
                  if borough == 1
                      minx = rx[1]
                      miny = ry[1]
                      maxx = rx[2]
                      maxy = ry[2]
                  else
                      minx = minimum([rx[1], minx])
                      miny = minimum([ry[1], miny])
                      maxx = maximum([rx[2], maxx])
                      maxy = maximum([ry[2], maxy])
                  end
              end
              return minx, miny, maxx, maxy
          end
      end

julia> metrominmax(gt)
(-116.19280000030994, 5336.966000000015, 655653.8499999996, 1.2203015020000003e6)
```
This is a rather simplistic method, but illustrates how it is possible to use the individual points from a geometry.
By filtering, a subset of the geometries in the full dataset can be used (here, Hartlepool, Middlesborough and Redcar and Cleveland).
```julia
metrominmax(gt |> Filter(row -> row.LAD23CD in ["E06000001", "E06000002", "E06000003"]))
(439865.29920000024, 510800.3044000007, 478448.5499999998, 537152.0012999997)
```
There is a more efficient built-in method to find this same information - `boundingbox()`. Note that this function just takes the geometry column
rather than the whole GeoTable. Using this, we can get the same results as above:
```
julia> boundingbox(gt.geometry)
Box{2,Float64}
├─ min: Point(-116.19280000030994, 5336.966000000015)
└─ max: Point(655653.8499999996, 1.2203015020000003e6)

julia> boundingbox((gt |> Filter(row -> row.LAD23CD in ["E06000001", "E06000002", "E06000003"])).geometry)
Box{2,Float64}
├─ min: Point(439865.29920000024, 510800.3044000007)
└─ max: Point(478448.5499999998, 537152.0012999997)
```
Again, we can dig out the individual coordinate values from this `Box`:
```
julia> bb = boundingbox((gt |> Filter(row -> row.LAD23CD in ["E06000001", "E06000002", "E06000003"])).geometry)
Box{2,Float64}
├─ min: Point(439865.29920000024, 510800.3044000007)
└─ max: Point(478448.5499999998, 537152.0012999997)

julia> bb.min
Point(439865.29920000024, 510800.3044000007)

julia> coordinates(bb.min)
Vec(439865.29920000024, 510800.3044000007)

julia> coordinates(bb.min)[1]
439865.29920000024
```
### Joining a GeoTable with a dataframe
It is possible to add (join) the data in a dataframe to a GeoTable but this must be done in several steps:
  1. Extract the values from the GeoTable
  2. Convert the values table to a dataframe
  3. Join the dataframe so created with the new dataframe
  4. Rejoin the combined dataframe with the geometry from the GeoTable using `georef()`

Steps 1 and 2 can be achieved together as:
```
gtvalues = values(gt) |> DataFrame
361×8 DataFrame
 Row │ LAD23CD    LAD23NM                LAD23NMW           BNG_E   BNG_N   LONG      LAT       GlobalID
     │ String?    String?                String?            Int64?  Int64?  Float64?  Float64?  String?
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ E06000001  Hartlepool             missing            447160  531474  -1.27018   54.6761  ed77cf59-0f99-40ee-8ce0-3c495b04…
   2 │ E06000002  Middlesbrough          missing            451141  516887  -1.21099   54.5447  12aebc50-49df-4d0f-af2e-7b18e592…
   3 │ E06000003  Redcar and Cleveland   missing            464361  519597  -1.00608   54.5675  b073197d-76d1-468b-a1ca-e71a9465…
   4 │ E06000004  Stockton-on-Tees       missing            444940  518179  -1.30664   54.5569  a722dfde-1ff3-4a0c-90e7-4b7cc413…
   5 │ E06000005  Darlington             missing            428029  515648  -1.56835   54.5353  7341c0fb-23f7-4180-9f8f-f11c6710…
  ⋮  │     ⋮                ⋮                    ⋮            ⋮       ⋮        ⋮         ⋮                      ⋮
 357 │ W06000020  Torfaen                Torfaen            327459  200480  -3.05101   51.6984  05ef8b3d-0707-4b64-839a-756f2d1a…
 358 │ W06000021  Monmouthshire          Sir Fynwy          337812  209231  -2.9028    51.7783  f5fb84c2-58a5-48f8-a95c-f99ff6f6…
 359 │ W06000022  Newport                Casnewydd          337897  187432  -2.89769   51.5823  f3bf10e2-5a9e-465d-a8a6-e1c3e1aa…
 360 │ W06000023  Powys                  Powys              302329  273254  -3.43531   52.3486  9da0c14d-8d93-4159-aa7b-d90eb47f…
 361 │ W06000024  Merthyr Tydfil         Merthyr Tudful     305916  206404  -3.36425   51.7484  50d5293f-038d-4dd2-a886-b06eff4f…
                                                                                                                  351 rows omitted
```
Now, suppose we have population data for subset of Local Authorities in a separate dataframe:
```
 julia> df=DataFrame(LAD23CD = ["E06000001", "E06000002", "E06000003"],
                     LA_Name = ["Hartlepool", "Middlesbrough", "Redcar and Cleveland"],
                     POP = [92571, 143734, 136616])
3×3 DataFrame
 Row │ LAD23CD    LA_Name               POP    
     │ String     String                Int64
─────┼─────────────────────────────────────────
   1 │ E06000001  Hartlepool             92571
   2 │ E06000002  Middlesbrough         143734
   3 │ E06000003  Redcar and Cleveland  136616
```
We can easily join these two dataframes using standard DataFrames join functions. However, we need to ensure that the order and
number of rows of the resulting dataframe exactly matches the original GeoTable. This is so that `georef` matches the correct data
to the correct geometry. The `georef` function puts the values together with geometry more or less as a simple `hcat` and does not
make any attempt to match the rows.
The easiest way to join the dataframes with this ordering constraint is to use the in-place `leftjoin!()`, using the dataframe extracted from
the original GeoTable as the left-hand dataframe.
```
julia> newdf = leftjoin!(gtvalues, df, on=:LAD23CD, matchmissing=:equal)
361×10 DataFrame
 Row │ LAD23CD    LAD23NM                LAD23NMW           BNG_E   BNG_N   LONG      LAT       GlobalID                           LA_Name               POP     
     │ String?    String?                String?            Int64?  Int64?  Float64?  Float64?  String?                            String?               Int64?
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ E06000001  Hartlepool             missing            447160  531474  -1.27018   54.6761  ed77cf59-0f99-40ee-8ce0-3c495b04…  Hartlepool              92571
   2 │ E06000002  Middlesbrough          missing            451141  516887  -1.21099   54.5447  12aebc50-49df-4d0f-af2e-7b18e592…  Middlesbrough          143734
   3 │ E06000003  Redcar and Cleveland   missing            464361  519597  -1.00608   54.5675  b073197d-76d1-468b-a1ca-e71a9465…  Redcar and Cleveland   136616
   4 │ E06000004  Stockton-on-Tees       missing            444940  518179  -1.30664   54.5569  a722dfde-1ff3-4a0c-90e7-4b7cc413…  missing               missing
   5 │ E06000005  Darlington             missing            428029  515648  -1.56835   54.5353  7341c0fb-23f7-4180-9f8f-f11c6710…  missing               missing
  ⋮  │     ⋮                ⋮                    ⋮            ⋮       ⋮        ⋮         ⋮                      ⋮                           ⋮               ⋮
 357 │ W06000020  Torfaen                Torfaen            327459  200480  -3.05101   51.6984  05ef8b3d-0707-4b64-839a-756f2d1a…  missing               missing
 358 │ W06000021  Monmouthshire          Sir Fynwy          337812  209231  -2.9028    51.7783  f5fb84c2-58a5-48f8-a95c-f99ff6f6…  missing               missing
 359 │ W06000022  Newport                Casnewydd          337897  187432  -2.89769   51.5823  f3bf10e2-5a9e-465d-a8a6-e1c3e1aa…  missing               missing
 360 │ W06000023  Powys                  Powys              302329  273254  -3.43531   52.3486  9da0c14d-8d93-4159-aa7b-d90eb47f…  missing               missing
 361 │ W06000024  Merthyr Tydfil         Merthyr Tudful     305916  206404  -3.36425   51.7484  50d5293f-038d-4dd2-a886-b06eff4f…  missing               missing
                                                                                                                                                 351 rows omitted
```
Now, finally, combine the new dataframe with the original geometry:
```
julia> newgt = georef(newdf, gt.geometry)
361×11 GeoTable over 361 GeometrySet{2,Float64}
┌─────────────┬─────────────────────────────┬─────────────┬─────────────┬─────────────┬────────────┬────────────┬──────────────────────────────────────┬──────────────────────┬─────────────┬─────────────
│   LAD23CD   │           LAD23NM           │  LAD23NMW   │    BNG_E    │    BNG_N    │    LONG    │    LAT     │               GlobalID               │       LA_Name        │     POP     │     geomet ⋯
│ Categorical │         Categorical         │ Categorical │ Categorical │ Categorical │ Continuous │ Continuous │             Categorical              │     Categorical      │ Categorical │   MultiPol ⋯
│  [NoUnits]  │          [NoUnits]          │  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │ [NoUnits]  │ [NoUnits]  │              [NoUnits]               │      [NoUnits]       │  [NoUnits]  │            ⋯
├─────────────┼─────────────────────────────┼─────────────┼─────────────┼─────────────┼────────────┼────────────┼──────────────────────────────────────┼──────────────────────┼─────────────┼─────────────
│  E06000001  │         Hartlepool          │   missing   │   447160    │   531474    │  -1.27018  │  54.6761   │ ed77cf59-0f99-40ee-8ce0-3c495b0436dd │      Hartlepool      │    92571    │ Multi(2×Po ⋯
│  E06000002  │        Middlesbrough        │   missing   │   451141    │   516887    │  -1.21099  │  54.5447   │ 12aebc50-49df-4d0f-af2e-7b18e5928ad7 │    Middlesbrough     │   143734    │ Multi(4×Po ⋯
│  E06000003  │    Redcar and Cleveland     │   missing   │   464361    │   519597    │  -1.00608  │  54.5675   │ b073197d-76d1-468b-a1ca-e71a9465fc1e │ Redcar and Cleveland │   136616    │ Multi(3×Po ⋯
│  E06000004  │      Stockton-on-Tees       │   missing   │   444940    │   518179    │  -1.30664  │  54.5569   │ a722dfde-1ff3-4a0c-90e7-4b7cc413ba49 │       missing        │   missing   │ Multi(6×Po ⋯
│  E06000005  │         Darlington          │   missing   │   428029    │   515648    │  -1.56835  │  54.5353   │ 7341c0fb-23f7-4180-9f8f-f11c67107389 │       missing        │   missing   │ Multi(1×Po ⋯
│  E06000006  │           Halton            │   missing   │   354246    │   382146    │  -2.68853  │  53.3342   │ fbd4f0f4-0d8c-4f38-8abf-6804e84c4ace │       missing        │   missing   │ Multi(2×Po ⋯
│  E06000007  │         Warrington          │   missing   │   362744    │   388457    │  -2.56167  │  53.3916   │ bb0be773-54c4-4af5-9446-b9378094e644 │       missing        │   missing   │ Multi(1×Po ⋯
│  E06000008  │    Blackburn with Darwen    │   missing   │   369489    │   422806    │  -2.46361  │  53.7008   │ 6bd5145d-d596-4f62-b43e-8b526829bd61 │       missing        │   missing   │ Multi(1×Po ⋯
│  E06000009  │          Blackpool          │   missing   │   332819    │   436635    │  -3.02199  │  53.8216   │ 04541f38-9b18-4360-8ec1-c01f8eeb39ec │       missing        │   missing   │ Multi(1×Po ⋯
│      ⋮      │              ⋮              │      ⋮      │      ⋮      │      ⋮      │     ⋮      │     ⋮      │                  ⋮                   │          ⋮           │      ⋮      │         ⋮  ⋱
└─────────────┴─────────────────────────────┴─────────────┴─────────────┴─────────────┴────────────┴────────────┴──────────────────────────────────────┴──────────────────────┴─────────────┴─────────────
                                                                                                                                                                             1 column and 352 rows omitted
```
If the order of `newdf` has been mixed up, and no longer matches the original order of the GeoTable, it will not easily be possible to spot it here. It may only become aparent when the data are inspected
graphically. As a simple check, we can try:
```
julia> boundingbox((newgt |> Filter(row -> row.LAD23CD in ["E06000001", "E06000002", "E06000003"])).geometry)
Box{2,Float64}
├─ min: Point(439865.29920000024, 510800.3044000007)
└─ max: Point(478448.5499999998, 537152.0012999997)
```
and note that these are indeed the same as originally.

## Visualising the GeoTable
tbc
