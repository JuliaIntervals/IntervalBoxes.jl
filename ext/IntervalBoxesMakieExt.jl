module IntervalBoxesMakieExt

using IntervalBoxes: IntervalBox
using Makie
using IntervalArithmetic: inf, diam

function _to_rect(b::IntervalBox{2})
    Rect2f(inf(b[1]), inf(b[2]), diam(b[1]), diam(b[2]))
end

@recipe(PlotIntervalBox, intervalboxes) do scene
    Attributes(
        color = (:blue, 0.3),
        strokecolor = :black,
        strokewidth = 1,
    )
end

function Makie.plot!(p::PlotIntervalBox{<:Tuple{<:IntervalBox{2}}})
    box = p.intervalboxes
    rect = @lift [_to_rect($box)]
    poly!(p, rect; color=p.color, strokecolor=p.strokecolor, strokewidth=p.strokewidth)
    return p
end

function Makie.plot!(p::PlotIntervalBox{<:Tuple{AbstractVector{<:IntervalBox{2}}}})
    boxes = p.intervalboxes
    rects = @lift _to_rect.($boxes)
    poly!(p, rects; color=p.color, strokecolor=p.strokecolor, strokewidth=p.strokewidth)
    return p
end

# Also support poly() directly
function Makie.convert_arguments(P::Type{<:Poly}, box::IntervalBox{2})
    return Makie.convert_arguments(P, [_to_rect(box)])
end

function Makie.convert_arguments(P::Type{<:Poly}, boxes::AbstractVector{<:IntervalBox{2}})
    return Makie.convert_arguments(P, _to_rect.(boxes))
end

end
