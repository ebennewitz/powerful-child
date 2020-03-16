using Shapes
using Test
#======================================================#
# Runtests.jl checks that the calculated area and perimeter
# of a regular polygon is correct. We check the cases
# of a triangle, square and hexagon
#======================================================#

#global tolerance
tol = 1e-13

#triangle test
tri = RegPolygon(3,1)
@test Perimeter(tri) == tri.sides*tri.length
@test isapprox( Area(tri) , tri.length/2 * sqrt(tri.length^2 - (0.5 * tri.length)^2), atol = tol )

#square test
sq = RegPolygon(4,1)
@test Perimeter(sq) == sq.sides*sq.length
@test isapprox( Area(sq) , sq.length^2, atol = tol )
#
#hexagon test
hex = RegPolygon(6,1)
@test Perimeter(hex) == 6*hex.length
@test isapprox( Area(hex) , 3 * sqrt(3) / 2 * hex.length^2, atol = tol )

#Check large n limit --> circle
cir = RegPolygon(Int(1e15), 1)
r = Apothem(cir)
@test isapprox( Perimeter(cir) , 2*pi*r , atol = tol)
@test isapprox( Area(cir) , pi*r^2, atol = tol)
