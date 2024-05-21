using IntervalArithmetic
using Test

@testset "IntervalBox" begin

    setdisplay(:standard, sigfigs=6)

    X = IntervalBox(1..2, 3..4)
    @test typeof(X) == IntervalBox{2,Float64,Interval{Float64}}
    @test string(X) == "[1.0, 2.0] × [3.0, 4.0]"

    s = sprint(show, MIME("text/plain"), X)
    @test s == "[1.0, 2.0] × [3.0, 4.0]"

    X = IntervalBox(1.1..1.2, 2.1..2.2)
    @test string(X) == "[1.09999, 1.20001] × [2.09999, 2.20001]"

    X = IntervalBox(-Inf..Inf, -Inf..Inf)
    @test string(X) == "(-∞, ∞)²"

    setdisplay(:full)
    @test string(X) == "IntervalBox(BareInterval(-Inf, Inf), 2)"


    setdisplay(:infsup)
    a = IntervalBox(1..2, 2..3)
    @test string(a) == "[1.0, 2.0] × [2.0, 3.0]"

    b = IntervalBox(emptyinterval(Float64), 2)
    @test string(b) == "∅²"

    c = IntervalBox(1..2, 1)
    @test string(c) == "[1.0, 2.0]¹"

    setdisplay(:midpoint)
    @test string(a) == "(1.5 ± 0.5) × (2.5 ± 0.5)"
    @test string(b) == "∅²"
    @test string(c) == "(1.5 ± 0.5)¹"
end

