module IntervalBoxesMakieExt

using IntervalBoxes: IntervalBox
using Makie
using IntervalArithmetic: inf, diam

function _to_rect(b::IntervalBox{2})
    Rect2f(inf(b[1]), inf(b[2]), diam(b[1]), diam(b[2]))
end

function Makie.convert_arguments(P::Type{<:Poly}, box::IntervalBox{2})
    return Makie.convert_arguments(P, [_to_rect(box)])
end

function Makie.convert_arguments(P::Type{<:Poly}, boxes::AbstractVector{<:IntervalBox{2}})
    return Makie.convert_arguments(P, _to_rect.(boxes))
end

end
