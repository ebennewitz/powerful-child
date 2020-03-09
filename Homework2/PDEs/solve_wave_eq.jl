using PDEs      #Package created for the purpose of solving PDEs
using Plots
gr()

#===========================================#
#      Calculate the Energy of the Wave     #
#===========================================#
function E_wave(state)
    psi, psi_dot = state
    psi_prime = deriv(psi)
    k_energy = 1/2*l2norm(psi_prime)^2
    p_energy = 1/2*l2norm(psi_dot)^2
    energy = k_energy  + p_energy
    energy, k_energy, p_energy
end

#=============================================#
# Solve the Wave Equation with ansatz f(t,x)  #
#=============================================#
function evolve_wave(f, dfdt, xs, t_steps, dt)
    # Define the initial state for the wave_eq fxn
    f_init(x) = f(0, x)
    dfdt_init(x) = dfdt(0, x)
    f0 = [ sample(f_init, 100), sample(dfdt_init ,100) ]
    # Solve the wave equation to obtain the time evolution according to the wave equation
    f_evolve = rk2integrate( wave_eq, f0, dt, t_steps)
    wave_evolution = [[evaluate(f_evolve[i][1], x) for x in xs] for i in 1:t_steps]
    #============================================#
    #      Calculating conserved quantities      #
    #============================================#
    E0, K0, P0 = E_wave(f0)
    E_convsered = [ E0 ]
    K_energy = [ K0 ]
    P_energy = [ P0 ]
    for i = 1:t_steps
        Et, Kt, Pt = E_wave(f_evolve[i])
        push!(E_convsered, Et)
        push!(K_energy, Kt)
        push!(P_energy, Pt)
    end
    E_values = [E_convsered, K_energy, P_energy]
    wave_evolution, E_values
end

#============================================#
#           Initialize ansatz                #
#============================================#
k = π
w = 1/(2*π)
A = 10
# Defining our ansatz funciton f(t,x) and its
# time derivative dfdt(t,x)
f(t, x) = 10*A*sin(k*x)*sin(w*t)
dfdt(t, x) = 10*A*w*sin(k*x)*cos(w*t)

f_2(t, x) = A*sin(2*k*x + w*t)
dfdt_2(t, x) = A*w*cos(2*k*x + w*t)

xs = [i/1000 for i in 0:1000]
t_steps, dt = 100, 0.01
wave_evolution1, E_values1 = evolve_wave(f, dfdt, xs, t_steps, dt)
wave_evolution2, E_values2 = evolve_wave(f_2, dfdt_2, xs, t_steps, dt)
#============================================#
#    Plotting/Animating the solutions        #
#============================================#
print("Making animation")
anim = @animate for i ∈ 1:100
    Dt = Integer(t_steps/100)
    plot(xs, wave_evolution1[Dt*i], lw = 2, ylims = (-10*A,10*A), xlabel = "x", title = "Evolution of a wave");
    plot!(xs, wave_evolution2[Dt*i], lw = 2);
end

gif(anim, "PlotsHW2/wave_evolution_anmiation_dt_$dt.gif", fps = 15);

print("Making E conservation plot")
t_vals = [t*dt for t in 0:t_steps]
E_plot = plot(  t_vals, [E_values1[1]/E_values1[1][1] , E_values2[1]/E_values2[1][1]],
                linestyle = :dot,
                ylims = (0, 1.1),
                lw = 3,
                title = "Energy Conservation",
                xlabel = "t",
                ylabel = "E(t)/E0");

savefig(E_plot, "PlotsHW2/Energy_conservation_dt_$dt.png")
