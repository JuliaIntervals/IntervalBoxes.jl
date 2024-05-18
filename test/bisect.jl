using IntervalArithmetic
using Test


@testset "`bisect` function" begin
    X = (0..1) × (0..2)
    @test bisect(X, 0.5) == ( (0..1) × (0..1), (0..1) × (1..2) )
    @test bisect(X, 0.25) == ( (0..1) × (0..0.5), (0..1) × (0.5..2) )
    @test bisect(X, 1, 0.5) == ( (0..0.5) × (0..2), (0.5..1) × (0..2) )
    @test bisect(X, 1, 0.25) == ( (0..0.25) × (0..2), (0.25..1) × (0..2) )

    @test bisect(X) ==  (IntervalBox(0..1, interval(0.0, 0.9921875)),
                         IntervalBox(0..1, interval(0.9921875, 2.0)))

    X = (-Inf..Inf) × (-Inf..Inf)
    @test bisect(X, 0.5) == ( (-Inf..0) × (-Inf..Inf), (0..Inf) × (-Inf..Inf))
end
