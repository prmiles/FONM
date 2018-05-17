% Riemann-Liouville Fractional Derivative (RLFD) using Finite Difference
% (FD) and Gaussian Quadrature (GQ)

% setup workspace
clear; close all; clc;

addpath('../src');

% Define test problem
f = @(x) exp(2*x);
exact_value = 13.8153;
alpha = 0.9; % order of FD

N = 20;
t0 = 0;
t = 1;

dt = 1e-6;

[dalphadt, int1, int2] = RLFD_GLQ(f, alpha, N, dt, t0, t)
 
fprintf('N = %i, Computed = %4.4f, Exact = %4.4f\n', N, dalphadt, exact_value);
fprintf('dt = %4.2e, t0 = %4.2f, t = %4.2f\n', dt, t0, t);
fprintf('F(t_{j+1}) = %4.4f\nF(t_{j}) = %4.4f\n', int1/gamma(1-alpha), int2/gamma(1-alpha));