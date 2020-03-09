# Solving the wave equation

Included in this repository is a julia script which solves the time evolution of a wave from the wave equation. The structure of the code is the follows:
- `PDEs`: A package which contains functions that are useful for integration. In here, we define the basis function, Runge-Kutta integration and more. These are all used in the script `solve_wave_eq.jl` to evolve the wavefunction. 
- `solve_wave_eq.jl`: A script which solves the wave equation for two different functions. It then plots the time evolution of the waves and calcuates the energy of the wave. Since we have no external force on the system, energy should be conserved. 



## Numerical Results
We can produce plots that show how the wave is evolving in time for the domain `[0,1]`. We chose to implement the boundary conditions `dfdt(t,0) = dfdt(t, 1) = 0` such that the derivative of the wave is always zero. In addition, we chose to implement the integration with a piecewise-linear discretization method. 

We will show two different cases, one with a small time step and another where the time step results in a large numerical error. For each case, we will also show whether or not energy conservation holds. 

The plots below were prduced for two different inital functions and thier first time derivative:
```julia
#blue curve
f(t, x) = 10*A*sin(k*x)*sin(w*t)
dfdt(t, x) = 10*A*w*sin(k*x)*cos(w*t)

#orange curve
f_2(t, x) = A*sin(2*k*x + w*t)
dfdt_2(t, x) = A*w*cos(2*k*x + w*t)
```
Note that these functions also go to zero at the boundary conditions, thus we have decided to pin the wave at the boundary. 
### Good resoltuion (dt = 0.001)
For a good choice of `dt`, we get a numerically accurate evolution of a wave. We can check the numerical error by calculating the energy over time `E(t)` in the lower plot. We see that the energy is constant throughout the time evolution, just as we expect for a physical system.  
![ Waves evolved with good resolution (dt = 0.001) ](https://github.com/ebennewitz/powerful-child/blob/master/Homework2/PDEs/PlotsHW2/wave_evolution_anmiation_dt_0.001.gif)
![ Energy conservation with good resolution (dt = 0.001) ](https://github.com/ebennewitz/powerful-child/blob/master/Homework2/PDEs/PlotsHW2/Energy_conservation_dt_0.001.png)

### Bad resolution (dt = 0.01) 
However, for a bad choice of `dt`, we get a time evolution which explodes. We can see that the existance of a numerical error calculating the energy over time `E(t)` in the lower plot. We see that the energy is constant to start and then increases around the same time the curves in the animation explode. 
![ Waves evolved with bad resolution (dt = 0.01) ](https://github.com/ebennewitz/powerful-child/blob/master/Homework2/PDEs/PlotsHW2/wave_evolution_anmiation_dt_0.01.gif)
![ Energy conservation with good resolution (dt = 0.01) ](https://github.com/ebennewitz/powerful-child/blob/master/Homework2/PDEs/PlotsHW2/Energy_conservation_dt_0.01.png)
