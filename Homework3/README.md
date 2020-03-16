# Hydrodynamics

We explore the evolution of fluids, the development of shocks and how to handle them. In particluar, we will take a closer look at how the MINMOD slope limiter algorithm and [`Another...`] handle the discontinuities created by shocks. 
## Order of convergences
In order to better understand how well our algorithms are doing, we will calculate their order of convergence. An algorithm has order `n` convergence if:
```
|f_(deltax) - f_(deltax/2)| <= (deltax)^n
```
In particular, we calculate the convergence by constructing the profiles for three different cell resolutions. We use burgers for `N_cells = [64, 4*64, 8*64 ]` and compute the mean of the absolute value of the difference bewteen the lower two resolutions and the higher resolution. 
### Early Time (before shocks)
First, we will look at the converence of the flow before shocks have formed. In this region, we would expect a similar convergence for the linear and HRSC techniques, since no discontinuities have developed yet. By plotting the velocity profile of the fluid, we can see that shocks have yet to develop. We plot the profiles constructed at two resolutions for each type of slope limiter. In the convergence plot below, we show how the difference bewteen these two resolutions for each slope limiter behaves. 

![Fluid velocity profile](https://github.com/ebennewitz/powerful-child/blob/master/Homework3/Plots/Early_time_profiles.png)

![Convergence](https://github.com/ebennewitz/powerful-child/blob/master/Homework3/Plots/Early_time_convergence.png)

In the above plot, we show that both methods approximtely convergce at second order.
### Late Time (after shocks)
Second, we compute the convergence for the velocity profile after the shocks have formed. To see how the HRSC technique smoothes out the discontinutities, we show the velocity profiles computed at a later time. Since the burgers constructed without any method to handle shocks, becomes discontinuous, we do not plot the covergence. Instead we will look at the behavior of the minmod method at later times. 
![Fluid velocity profile](https://github.com/ebennewitz/powerful-child/blob/master/Homework3/Plots/Late_time_profiles.png)

Unlike early times, we see that the minmod converges closer to first order, in fact `~1.2`. 

![Convergence](https://github.com/ebennewitz/powerful-child/blob/master/Homework3/Plots/Late_time_convergence.png)
