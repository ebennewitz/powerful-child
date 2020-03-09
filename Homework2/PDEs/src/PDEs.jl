module PDEs

# Homework 2 for Computational Physics 2020:
# A Julia package that solves the scalar wave
# equation in 1+1 dimensions

#===================================================#
#           Important Structures
#===================================================#
# Function type...just as efficient as numpy or others
export Fun
struct Fun{T}
    coeffs::Vector{T}
end

# Adds vector addition to the +, must do becuase we define out own types
function Base.:+(f::Fun{T}, g::Fun{T}) where {T}
    Fun{T}(f.coeffs + g.coeffs)
end

# Adds vector subtraction to the -
function Base.:-(f::Fun{T}, g::Fun{T}) where {T}
    Fun{T}(f.coeffs - g.coeffs)
end

# Adds vector multiplication to * operation
function Base.:*(a::T, f::Fun{T}) where {T}
    Fun{T}(a * f.coeffs)
end

#===================================================#
#           Basis Functions
#===================================================#
# Basis Funciton hat(i, N, x)

export hat
function hat(i, N, x::T) where {T}
    @assert 0 <= i < N #gives me a condition on i
    h    = 1 / (N-1)
    xim1 = h * (i - 1)
    xi   = h * i
    xip1 = h * (i + 1)
    if x <= xim1
        return T(0) #zero slope outside
    elseif x <= xi
        return (x - xim1) / h
    elseif x <= xip1
        return - (x - xip1) / h
    else
        return T(0)
    end
end

#===================================================#
#           First and Second Derivatives
#===================================================#
export deriv
function deriv(f::Fun{T})::Fun{T} where {T}
    N = length(f.coeffs)
    h = 1/ T(N-1)
    deriv_coeffs = similar(f.coeffs)
    for i in 1:N
            if i==1
                deriv_coeffs[i] = (f.coeffs[2] - f.coeffs[1]) / h
            elseif i == N
                deriv_coeffs[i] = (f.coeffs[N] - f.coeffs[N-1]) / h
            else
                deriv_coeffs[i] = (f.coeffs[i+1] - f.coeffs[i-1]) / (2h)
            end
        end
        Fun{T}(deriv_coeffs)
    end

export deriv2
function deriv2(f::Fun{T})::Fun{T} where {T}
    N = length(f.coeffs)
    h = 1/ T(N-1)
    deriv2_coeffs = similar(f.coeffs)
    for i in 1:N
            #Edge Case
            if i==1
                deriv2_coeffs[i] = (f.coeffs[3] - 2*f.coeffs[2] + f.coeffs[1]) / (h^2)
            elseif i == N
                deriv2_coeffs[i] = (f.coeffs[N] - 2*f.coeffs[N-1] + f.coeffs[N-2]) / (h^2)
            #Internal Points
            else
                deriv2_coeffs[i] = (f.coeffs[i+1] - 2*f.coeffs[i] + f.coeffs[i-1]) / (h^2)
            end
        end
        Fun{T}(deriv2_coeffs)
    end

#===================================================#
#           Runge-Kutta Steps/Integration
#===================================================#

#     rk2step(f, y0, h)
#
# Take one RK2 step with:
#     f: right-hand-side function (y-> y')
#     y0: step vector
#     h: step size
# Output:
#     an array of values y(h)

export rk2step
function rk2step(f, y0, h)
    k0 = f(y0)
    y1 = y0 + h/2 * k0
    k1 = f(y1)
    y2 = y0 + h*k1
    y2
end


#     rk2integration(f, y0, h, n)
#
# Takes n RK2 steps with:
#     f: right-hand-side function (y-> y')
#     y: step vector
#     h: step size
#     n: number of steps
# Output:
#     approximation of y(h)

export rk2integrate
function rk2integrate(f, y0, h, n)
    res  = [y0]
    for i in 1:n
        y1 = rk2step(f, y0, h)
        push!(res, y1) #append
        y0 = y1
    end
    res
end

# Calculate the integraitons of the function to get the norm
# quad(f)
export quad
function quad(f::Fun{T}) where {T}
    N = length(f.coeffs)
    h = 1/ T(N-1)
    s = T(0)
    for i in 0:N-1
        #compact notation
        #   w = (i==0 || i==N-1 ? T(0.5) : T(1)) * h

        #boundary basis funcitons have half the area
        if i==0 || i==N-1
            w = T(0.5)
        else
            w = T(1)
        end
        #add up contriubtions from all basis functions
        s += w * h * f.coeffs[i+1]
    end
    s
end

export l2norm
function l2norm(f::Fun{T}) where {T}
    coeffs_abs2 = [abs(c)^2 for c in f.coeffs]
    sqrt(quad(Fun{T}(coeffs_abs2)))
end
#===================================================#
#           Differential Equations
#===================================================#
export harmonic
function harmonic(state)
    p, v = state
    [v, -p]
end

export wave_eq
function wave_eq(state_fxn)
    psi, psi_dot = state_fxn
    psi_dot.coeffs[1]   = 0 #sets wave to zero at x = 0
    psi_dot.coeffs[end] = 0 #sets wave to zero at x = 1
    [psi_dot, deriv2(psi)]
end

export diffuse
function diffuse(f)
    deriv2(f)
end

#===================================================#
#             Evaluation Functions
#===================================================#
# Sample function with inputs f<: Fun{}, and N colocation types
export sample
function sample(f, N)
    h = 1 / (N-1)
    coeffs = Float64[ f(h*i) for i in 0:(N-1)]
    Fun{Float64}(coeffs)
end
# Evaluate interpolates the Fun{T} for a input x
export evaluate
function evaluate(f::Fun{T}, x) where {T}
    N = length(f.coeffs)
    sum(f.coeffs[i+1] * hat(i, N, x) for i in 0:N-1)
end

end # module
