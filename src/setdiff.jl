_make_interval(::Type{Interval{T}}, x::T, y::T) where {T} = interval(x, y, trv)
_make_interval(::Type{BareInterval{T}}, x::T, y::T) where {T} = bareinterval(x, y)

"""
    _setdiff(x::Interval{T}, y::Interval{T})

Computes the set difference `x \\ y` and returns a tuple of two intervals.
If the set difference is only one interval or is empty, then the returned tuple contains 1
or 2 empty intervals.
"""
function _setdiff(x::I, y::I) where {T, I <: IntervalType{T}}

    if x isa Interval
        x = IntervalArithmetic.setdecoration(x, trv)
        y = IntervalArithmetic.setdecoration(y, trv)
    end

    intersection = intersect_interval(x, y)

    isempty_interval(intersection) && return (x, emptyinterval(x))
    isequal_interval(intersection, x) && return (emptyinterval(x), emptyinterval(x))  # x is subset of y; setdiff is empty

    if inf(x) == inf(intersection)
        return (_make_interval(I, sup(intersection), sup(x)), emptyinterval(x))
    elseif sup(x) == sup(intersection)
        return (_make_interval(I, inf(x), inf(intersection)), emptyinterval(x))
    else
        return (_make_interval(I, inf(x), inf(y)), _make_interval(I, sup(y), sup(x)))
    end

end


"""
    setdiff(A::IntervalBox{N,T}, B::IntervalBox{N,T})

Returns a vector of `IntervalBox`es that are in the set difference `A ∖ B`,
i.e. the set of `x` that are in `A` but not in `B`.

Algorithm: Start from the total overlap (in all directions);
expand each direction in turn.
"""
function setdiff(A::IntervalBox{N,T}, B::IntervalBox{N,T}) where {N,T}

    intersection = A ⊓ B
    isempty(intersection) && return [A]

    result_list = fill(emptyinterval.(A), 2 * N)
    offset = 0
    x = A.v
    @inbounds for i = 1:N
        tmp = _setdiff(A[i], B[i])
        @inbounds for j = 1:2
            x = setindex(x, tmp[j], i)
            result_list[offset+j] = IntervalBox(x)
        end
        offset += 2
        x = setindex(x, intersection[i], i)
    end

    return [X for X in result_list if !isempty(X)]
end
