# IntervalBoxes.jl

[![Build Status](https://github.com/dpsanders/IntervalBoxes.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/dpsanders/IntervalBoxes.jl/actions/workflows/CI.yml?query=branch%3Amain)


## Multi-dimensional interval boxes in Julia.

An **interval box** is a Cartesian product of `Interval`s (actually `BareInterval`s), as defined in [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl).
An interval box of dimension $n$ thus represents an axis-aligned *set* in Euclidean space $\mathbb{R}^n$.


## Basic usage

```jl
julia> X = IntervalBox(1..3, 4..6)
[1.0, 3.0] × [4.0, 6.0]

julia> Y = IntervalBox(2..5, 2)
[2.0, 5.0]²

julia> X ∩ Y
[2.0, 3.0] × [4.0, 5.0]

julia> X ∪ Y
[1.0, 5.0] × [2.0, 6.0]

julia> [2, 5] ∈ X ∩ Y
true
```

We treat `IntervalBox`es as sets as much as possible, and extend Julia's set operations
to act on these objects.

Note that the `∪` operator produces the *interval hull* of the union
(i.e. the smallest interval box that contains the union).


## Authors
Copyright by JuliaIntervals contributors 2017–2024.

This code was originally in `IntervalArithmetic.jl`, but was removed. 
The git history can be found in that repo.

