# This file is part of the IntervalArithmetic.jl package; MIT licensed

"""An `IntervalBox` is an `N`-dimensional rectangular box, given
by a Cartesian product of a vector of `N` `Interval`s.
"""

const IntervalType{T} = Union{Interval{T}, BareInterval{T}}

struct IntervalBox{N, T, I <: IntervalType{T}}
    v::SVector{N, I}

    function IntervalBox{N,T,I}(v::SVector{N,I}) where {N, T, I <: IntervalType{T}}
        if any(isempty_interval, v)
            return new{N,T,I}(emptyinterval.(v))
        else
            return new{N,T,I}(v)
        end
    end
end

IntervalBox(v::SVector{N, I}) where {N,T,I <: IntervalType{T}} = IntervalBox{N,T,I}(v)

IntervalBox(x::IntervalType) = IntervalBox( SVector(x) )  # single interval treated as tuple with one element

IntervalBox(x::IntervalType...) = IntervalBox(SVector(x))
IntervalBox(x::SVector) = IntervalBox(interval.(x))
IntervalBox(x::Tuple) = IntervalBox(SVector(x))
IntervalBox(x::Real) = IntervalBox(interval.(x))
# IntervalBox(x...) = IntervalBox(x)
# IntervalBox(x) = IntervalBox(x...)
IntervalBox(X::IntervalBox, n) = foldl(×, Iterators.repeated(X, n))

# construct from two vectors giving bottom and top corners:
IntervalBox(lo::AbstractVector, hi::AbstractVector) = IntervalBox(interval.(lo, hi))

# IntervalBox(lo::SVector{N,T}, hi::SVector{N,T}) where {N,T} = IntervalBox(interval.(lo, hi))


Base.@propagate_inbounds Base.getindex(X::IntervalBox, i) = X.v[i]

setindex(X::IntervalBox, y, i) = IntervalBox( setindex(X.v, y, i) )

# iteration:

iterate(X::IntervalBox{N,T}) where {N, T} = (X[1], 1)

function iterate(X::IntervalBox{N,T}, state) where {N,T}
    (state == N) && return nothing

    return X[state+1], state+1
end

eltype(::Type{IntervalBox{N,T,I}}) where {N,T,I} = I

Base.eltype(x::IntervalBox{N,T,I}) where {N,T,I} = I
numtype(x::IntervalBox{N,T,I}) where {N,T,I} = T

length(X::IntervalBox{N,T,I}) where {N,T,I} = N



# IntervalBox(xx) = IntervalBox(Interval.(xx))
# IntervalBox(xx::SVector) where {N,T} = IntervalBox(Interval.(xx))


## arithmetic operations
# Note that standard arithmetic operations are implemented automatically by FixedSizeArrays.jl
"""
    mid(X::IntervalBox, α=0.5)

Return a vector of the `mid` of each interval composing the `IntervalBox`.

See `mid(X::Interval, α=0.5)` for more informations.
"""
mid(X::IntervalBox) = mid.(X)
mid(X::IntervalBox, α) = mid.(X, α)

big(X::IntervalBox) = big.(X)


## set operations

⊆(X::IntervalBox{N}, Y::IntervalBox{N}) where {N} = all(issubset_interval.(X, Y))

⊓(X::IntervalBox{N}, Y::IntervalBox{N}) where {N} =
    IntervalBox(intersect_interval.(X.v, Y.v))
⊔(X::IntervalBox{N}, Y::IntervalBox{N}) where {N} =
    IntervalBox(hull.(X.v, Y.v))

∈(X::AbstractVector, Y::IntervalBox{N,T}) where {N,T} = all(in_interval.(X, Y))
∈(X, Y::IntervalBox{N,T}) where {N,T} = throw(ArgumentError("$X ∈ $Y is not defined"))

# mixing intervals with one-dimensional interval boxes
# for op in (:⊆, :⊂, :⊃, :⊓, :⊔)
#     @eval $(op)(a::Interval, X::IntervalBox{1}) = $(op)(a, first(X))
#     @eval $(op)(X::IntervalBox{1}, a::Interval) = $(op)(first(X), a)
# end


isempty(X::IntervalBox) = any(isempty_interval, X)

diam(X::IntervalBox) = maximum(diam, X)

emptyinterval(X::IntervalBox{N,T}) where {N,T} = emptyinterval.(X)
bareinterval(X::IntervalBox{N,T}) where {N,T} = bareinterval.(X)

isbounded(X::IntervalBox) = all(isbounded, X)

isinterior(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) where {N,T} = all(isinterior.(X, Y))

# contains_zero(X::SVector) = 
# contains_zero(X::IntervalBox) = all(contains_zero.(X))


# Cartesian product:
×(a::IntervalType...) = IntervalBox(a...)
×(a::IntervalType, b::IntervalBox) = IntervalBox(a, b.v...)
×(a::IntervalBox, b::IntervalType) = IntervalBox(a.v..., b)
×(a::IntervalBox, b::IntervalBox) = IntervalBox(a.v..., b.v...)

IntervalBox(x::IntervalType, ::Val{n}) where {n} = IntervalBox(SVector(ntuple( _ -> x, Val(n) )))

IntervalBox(x::IntervalType, n::Int) = IntervalBox(x, Val(n))

dot(x::IntervalBox, y::IntervalBox) = dot(x.v, y.v)

Base.:(==)(x::IntervalBox, y::IntervalBox) = all(isequal_interval.(x.v, y.v))


# """
#     mince(x::IntervalBox, n::Int)

# Splits `x` in `n` intervals in each dimension of the same diameter. These
# intervals are combined in all possible `IntervalBox`-es, which are returned
# as a vector.
# """
# @inline mince(x::IntervalBox{N,T}, n::Int) where {N,T} =
#     mince(x, ntuple(_ -> n, N))

# """
#     mince(x::IntervalBox, ncuts::::NTuple{N,Int})

# Splits `x[i]` in `ncuts[i]` intervals . These intervals are
# combined in all possible `IntervalBox`-es, which are returned
# as a vector.
# """
# @inline function mince(x::IntervalBox{N,T}, ncuts::NTuple{N,Int}) where {N,T}
#     minced_intervals = [mince(x[i], ncuts[i]) for i in 1:N]
#     minced_boxes = Vector{IntervalBox{N,T}}(undef, prod(ncuts))

#     for (k, cut_indices) in enumerate(CartesianIndices(ncuts))
#         minced_boxes[k] = IntervalBox([minced_intervals[i][cut_indices[i]] for i in 1:N])
#     end
#     return minced_boxes
# end


hull(a::IntervalBox{N,T}, b::IntervalBox{N,T}) where {N,T} = IntervalBox(hull.(a[:], b[:]))
hull(a::Vector{IntervalBox{N,T}}) where {N,T} = hull(a...)

"""
    zero(::IntervalBox)

Return the zero interval box of dimension `N` in the numeric type `T`.
"""
zero(x::IntervalBox) = zero.(x)

"""
    symmetric_box(N, T)

Return the symmetric interval box of dimension `N` in the numeric type `T`,
each side is `Interval(-1, 1)`.
"""
symmetric_box(N, ::Type{T}) where T<:Real = IntervalBox(Interval{T}(-1, 1), N)
