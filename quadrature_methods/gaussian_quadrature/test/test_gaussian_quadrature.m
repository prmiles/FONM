% Riemann-Liouville Fractional Derivative (RLFD) using Finite Difference
% (FD) and Gaussian Quadrature (GQ)

% setup workspace
clear; close all; clc;

% Define test problem
f = @(x) exp(2*x);
exact_value = 13.8153;
alpha = 0.9; % order of FD

N = 800;
t0 = 0;
t = 1;

% define grid
gridpoints = linspace(t0,t,N);
startpoints = gridpoints(1:end-1);
endpoints = gridpoints(2:end);

dt = (endpoints - startpoints)';
dt = dt(1); % all identical

% create gauss points & weights
gpoints1 = gauss_points(N-1, dt, t0,2);
gweights1 = gauss_weights(N-1, dt,2);

gpoints2 = gauss_points(N-2, dt, t0,2);
gweights2 = gauss_weights(N-2, dt,2);

% define kernel
ker = @(x,y) f(x).*(y-x).^(-alpha);

% % evaluate integral using gaussian quadrature
int1 = sum(gweights1.*ker(gpoints1,gridpoints(end)));
int2 = sum(gweights2.*ker(gpoints2,gridpoints(end-1)));

dalphadt = 1/(dt*gamma(1-alpha))*(int1 - int2);

fprintf('N = %i, Computed = %4.4f, Exact = %4.4f\n', N, dalphadt, exact_value);
fprintf('dt = %4.2f, t0 = %4.2f, t = %4.2f\n', dt, t0, t);
fprintf('F(t_{j+1}) = %4.4f\nF(t_{j}) = %4.4f\n', int1/gamma(1-alpha), int2/gamma(1-alpha));