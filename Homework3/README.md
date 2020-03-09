# Hydrodynamics

We explore the evolution of fluids, the development of shocks and how to handle them. In particluar, we will take a closer look at how the MINMOD slope limiter algorithm and [`Another...`] handle the discontinuities created by shocks. 
## Order of convergences
In order to better understand how well our algorithms are doing, we will calculate their order of convergence. An algorithm has order `n` convergence if:
```
|f_(deltax) - f_(deltax/2)| <= (deltax)^n
```

### Early Time (before shocks)

### Late Time (after shocks)
