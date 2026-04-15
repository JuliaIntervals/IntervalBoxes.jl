module IntervalBoxesPlotsExt

using IntervalBoxes: IntervalBox
using RecipesBase
using IntervalArithmetic: inf, sup

@recipe function f(box::IntervalBox{2})
    seriestype := :shape
    legend --> false
    fillalpha --> 0.3
    linecolor --> :black

    x_lo, x_hi = inf(box[1]), sup(box[1])
    y_lo, y_hi = inf(box[2]), sup(box[2])

    [x_lo, x_hi, x_hi, x_lo], [y_lo, y_lo, y_hi, y_hi]
end

@recipe function f(boxes::AbstractVector{<:IntervalBox{2}})
    for box in boxes
        @series begin
            box
        end
    end
end

end
