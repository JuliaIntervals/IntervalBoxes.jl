# IntervalBoxes.jl

[![Build Status](https://github.com/dpsanders/IntervalBoxes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dpsanders/IntervalBoxes.jl/actions/workflows/CI.yml?query=branch%3Amain)


## Multi-dimensional interval boxes in Julia

An **interval box** is a Cartesian product of `Interval`s (or `BareInterval`s), as defined in [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl).
An interval box of dimension $n$ thus represents an axis-aligned *set* in Euclidean space $\mathbb{R}^n$.


## Basic usage

### Constructing `IntervalBox`es
```jl

julia> using IntervalBoxes, IntervalArithmetic, IntervalArithmetic.Symbols

julia> X = IntervalBox(1..3, 4..6)
[1.0, 3.0]_com × [4.0, 6.0]_com

julia> Y = IntervalBox(2..5, 2)
[2.0, 5.0]_com²

julia> (1..3) × (4..6)   # \times<TAB>
[1.0, 3.0]_com × [4.0, 6.0]_com
```

We have defined `×` to be the Cartesian cross product operator, acting on `Interval`s and/or
`IntervalBox`es.


### Set operations
We treat `IntervalBox`es as sets as much as possible, and extend Julia's set operations
to act on these objects:

```jl
julia> X ⊓ Y
[2.0, 3.0]_trv × [4.0, 5.0]_trv

julia> X ⊔ Y
[1.0, 5.0]_trv × [2.0, 6.0]_trv

julia> using StaticArrays

julia> SVector(2, 5) ∈ X ⊓ Y
true
```

Note that the `⊔` operator produces the *interval hull* of the union
(i.e. the smallest interval box that contains the union).

One-dimensional intervals can also be treated as sets in the same way, as follows.
(These set operations are deliberately not defined in `IntervalArithmetic.jl`.)
```
julia> x = IntervalBox(1..3)
[1.0, 3.0]¹

julia> y = IntervalBox(2..4)
[2.0, 4.0]¹

julia> x ⊓ y
[2.0, 3.0]¹
```


### Range of multi-dimensional functions
Interval arithmetic allows us to compute an enclosure (in general, an over-estimate)
of the range of a multi-dimensional function. E.g.:
```jl
julia> f((x, y)) = x + y;

julia> f(X)
[5.0, 9.0]
```

Note that in order to use numbers in functions like this, the numbers must be wrapped
in `ExactReal` to specify that they are exact representations.
Alternatively the complete definition can be annotated with `@exact`:
```jl
julia> g1((x, y)) = ExactReal(2) * x + ExactReal(3) * y;

julia> g1(X)
[14.0, 24.0]_com

julia> @exact g2((x, y)) = 2x + 3y;

julia> g2(X)
[14.0, 24.0]_com
```


## Authors
Copyright by JuliaIntervals contributors 2017–2024.

This code was originally in `IntervalArithmetic.jl`, but was removed. 
The git history can be found in that repo.

