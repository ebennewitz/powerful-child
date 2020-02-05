module Shapes

# #=========================================================#
# This package computes the area and perimeter of
# a regular polygon. It does so with a object structure
# defined by RegPolygon. Since a regular polygon is
# defined to have equal side lengths, this object has
# two components: number of sides and the side length.
# We restrict the number of sides to be an Int64 while
# the side length can be any number. The functions Perimeter
# and Area compute the area and Perimeter of the RegPolygon.
# #=========================================================#

export RegPolygon
struct RegPolygon{T1<:Integer, T2 <: Real}
    sides::T1   #sides must be an integer
    length::T2  #legnth can be any real number
end

export Perimeter
function Perimeter(s::RegPolygon{<:Integer, <:Real})
    s.sides * s.length
end

export Apothem
function Apothem(s::RegPolygon{<:Integer, <:Real})
    a = s.length / (2 * tan(pi/s.sides))
end

export Area
function Area(s::RegPolygon{<:Integer, <:Real})
    p = Perimeter(s)                        #perimeter of shape
    a = s.length / (2 * tan(pi/s.sides))    #apothem of shape
    p*a/2                                   #Area of n-sided polygon
end

end # module
