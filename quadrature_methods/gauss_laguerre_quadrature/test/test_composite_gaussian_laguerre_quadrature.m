% Riemann-Liouville Fractional Derivative (RLFD) using Finite Difference
% (FD) and Gaussian Quadrature (GQ)

% setup workspace
clear; close all; clc;

addpath('../src');

% Define test problem
f = @(x) exp(2*x);
exact_value = 101.893;
alpha = 0.9; % order of FD
a = 0;
b = 2;
dt = 1e-6;

% Break interval into two components
% 1. Perform Gaussian quadrature from [a, b-bT]
bT = 0.2;
NGQ = 16;

% define grid for gaussian quadrature
gridpoints = linspace(a,b-bT,NGQ);
startpoints = gridpoints(1:end-1);
endpoints = gridpoints(2:end);
dtGQ = (endpoints - startpoints)';
dtGQ = dtGQ(1); % all identical

% create gauss points & weights
xGQ = gauss_points(NGQ-1, dtGQ, a);
wGQ = gauss_weights(NGQ-1, dtGQ);

% define kernel
kerQG = @(x,bQG) f(x).*(bQG-x).^(-alpha);

% evaluate integral using gaussian quadrature
int1GQ = sum(wGQ.*kerQG(xGQ,b));
int2GQ = sum(wGQ.*kerQG(xGQ,b-dt));

% 2. Perform Gauss-Laguerre quadrature form [b-bT,b]
NGL = 16;

% define Gauss-Laguerre points and weights
[xGL, wGL] = GaussLaguerre_2(NGL, 0, 2);

% define kernel
% ker1 = @(x,y) f(x).*(y-x).^(-alpha);
% ker2 = @(x,y) y.*f(y*x).*(y-y*x).^(-alpha);
ker = @(x,aa,bb) (bb-aa)^(1-alpha).*f((bb-aa).*x + aa).*(1-x).^(-alpha);

% evaluate integral using gauss-laguerre quadrature
int1GL = sum(wGL.*ker(1-exp(-xGL), b-bT, b));
int2GL = sum(wGL.*ker(1-exp(-xGL), b-bT, b-dt));

int1 = int1GQ + int1GL;
int2 = int2GQ + int2GL;

dalphadt = 1/(dt*gamma(1-alpha))*(int1 - int2);

fprintf('NGQ = %i, NGL = %i, Computed = %4.4f, Exact = %4.4f\n', NGQ, NGL, dalphadt, exact_value);
fprintf('dt = %4.2e, t0 = %4.2f, t = %4.2f\n', dt, a, b);
fprintf('F(t_{j+1}) = %4.4f\nF(t_{j}) = %4.4f\n', int1/gamma(1-alpha), int2/gamma(1-alpha));
fprintf('int1 = %4.4f, int2 = %4.4f\n', int1, int2);