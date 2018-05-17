function [A] = nonlinear_strain(alpha, dt, time, V, sigma_inf, sti)
% evaluation of strain using nonlinear approach
% alpha - fractional order
% dt - time step
% t - time at which evaluation occurs
% V - 
% sigma_inf - hyperelastic stress
% sti - starting index

d = sti:1:floor(time.*(1/dt));
A1 = V(d+1).*sigma_inf(floor(time.*(1/dt)) - (d) + 1);
A = (1/dt^(alpha)).*sum(A1); 
end