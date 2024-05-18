"""
    _setdiff(x::Interval{T}, y::Interval{T})

Computes the set difference x\\y and always returns a tuple of two intervals.
If the set difference is only one interval or is empty, then the returned tuple contains 1
or 2 empty intervals.
"""
function _setdiff(x::BareInterval{T}, y::BareInterval{T}) where T
    intersection = intersect_interval(x, y)

    isempty_interval(intersection) && return (x, emptyinterval(x))
    isequal_interval(intersection, x) && return (emptyinterval(x), emptyinterval(x))  # x is subset of y; setdiff is empty

    inf(x) == inf(intersection) && return (bareinterval(sup(intersection), sup(x)), emptyinterval(x))
    sup(x) == sup(intersection) && return (bareinterval(inf(x), inf(intersection)), emptyinterval(x))

    return (bareinterval(inf(x), inf(y)), bareinterval(sup(y), sup(x)))

end


"""
    setdiff(A::IntervalBox{N,T}, B::IntervalBox{N,T})

Returns a vector of `IntervalBox`es that are in the set difference `A ∖ B`,
i.e. the set of `x` that are in `A` but not in `B`.

Algorithm: Start from the total overlap (in all directions);
expand each direction in turn.
"""
function setdiff(A::IntervalBox{N,T}, B::IntervalBox{N,T}) where {N,T}

    intersection = A ∩ B
    isempty(intersection) && return [A]

    result_list = fill(IntervalBox(emptyinterval.(A)), 2 * N)
    offset = 0
    x = A.v
    @inbounds for i = 1:N
        tmp = _setdiff(A[i], B[i])
        @inbounds for j = 1:2
            x = setindex(x, tmp[j], i)
            result_list[offset+j] = IntervalBox{N, T}(x)
        end
        offset += 2
        x = setindex(x, intersection[i], i)
    end

    return [X for X in result_list if !isempty(X)]
end
