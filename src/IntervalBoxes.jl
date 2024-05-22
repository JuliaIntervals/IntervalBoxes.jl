module IntervalBoxes

using IntervalArithmetic
using StaticArrays

import IntervalArithmetic:
    emptyinterval, bisect, diam, hull, mid, mince, bareinterval, isinterior,
    isbounded

import Base:
    ∩, ∪, ⊆, +, -, *, /, ==, !=, eltype, length, size, getindex, setindex, iterate,
    broadcasted, setdiff, big, isempty, zero

export IntervalBox
export ×

include("intervalbox.jl")
include("arithmetic.jl")
include("setdiff.jl")
include("bisect.jl")
include("show.jl")

# Write your package code here.

end
