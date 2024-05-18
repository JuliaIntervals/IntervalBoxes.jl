using IntervalBoxes
using Test

@testset "IntervalBoxes.jl" begin
    include("multidim.jl")
    include("bisect.jl")
    include("display.jl")
end
