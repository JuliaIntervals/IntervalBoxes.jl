module IntervalBoxes

using IntervalArithmetic
using StaticArrays

import IntervalArithmetic: emptyinterval, bisect, diam, hull, mid, mince

import Base:
    ∩, ∪, +, -, *, /, ==, !=, eltype, length, size, getindex, setindex, iterate,
    broadcasted, setdiff, big

export IntervalBox
export ×

include("intervalbox.jl")
include("arithmetic.jl")
include("setdiff.jl")
include("bisect.jl")
include("show.jl")

# Write your package code here.

end
