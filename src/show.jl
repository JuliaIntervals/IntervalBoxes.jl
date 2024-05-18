
function _superscriptify(n::Integer)
    if 0 ≤ n ≤ 9
        return _superscript_digit(n)
    else
        len = ndigits(n)
        x = Vector{Char}(undef, len)
        i = 0
        while n > 0
            n, d = divrem(n, 10)
            x[len-i] = _superscript_digit(d)
            i += 1
        end
        return join(x)
    end
end

function _superscript_digit(n::Integer)
    if n == 0 return '⁰'
    elseif n == 1 return '¹'
    elseif n == 2 return '²'
    elseif n == 3 return '³'
    elseif n == 4 return '⁴'
    elseif n == 5 return '⁵'
    elseif n == 6 return '⁶'
    elseif n == 7 return '⁷'
    elseif n == 8 return '⁸'
    elseif n == 9 return '⁹'
    end
end


function representation(X::IntervalBox{N, T}, format=nothing) where {N, T}

    if format == nothing
        format = IntervalArithmetic.display_options.format  # default
    end

    n = format == :full ? N : _superscriptify(N)

    if isempty(X)
        format == :full && return string("IntervalBox(∅, ", n, ")")
        return string("∅", n)
    end

    x = first(X)
    if all(isequal_interval(x), X)
        if format == :full
            return string("IntervalBox(", IntervalArithmetic._str_repr(x, format), ", ", n, ")")
        elseif format == :midpoint
            return string("(", IntervalArithmetic._str_repr(x, format), ")", n)
        else
            return string(IntervalArithmetic._str_repr(x, format), n)
        end
    end

    if format == :full
        full_str = IntervalArithmetic._str_repr.(X.v, :full)
        return string("IntervalBox(", join(full_str, ", "), ")")
    elseif format == :midpoint
        return string("(", join(X.v, ") × ("), ")")
    else
        return join(string.(X.v), " × ")
    end

end


Base.show(io::IO, a::IntervalBox) = print(io, representation(a))
Base.show(io::IO, ::MIME"text/plain", a::IntervalBox) = print(io, representation(a))

