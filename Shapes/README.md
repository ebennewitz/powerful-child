# Shapes: A Julia Package

This package computes the area and perimeter of 2D regular polygons.

### RegPolygon
A n-sided regular polygon is one with n sides of equal length l. They can be completely defined by two numbers, the number of sides and the side length. This package uses a strucutre called RegPolygon to represent a regular polygon. We require the number of sides to be an Integer and the length can be any real number.

### Perimeter
The Perimeter function uses the simple formula P = n * l to output the Perimeter of the polygon

### Area
The Area function uses the formula A = 1/2 a * P where a is the apothem. The apothem is the distance from the midpoint of one side to the center of the shape. 

##Test

Included is a test function runtests.jl, which check that the functions compute the correct area and perimeter of a square, a triangle, and a hexagon
