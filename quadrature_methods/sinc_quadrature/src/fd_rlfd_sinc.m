function [dalphadt, out] = fd_rlfd_sinc(f, alpha, t, t0, dt, M)
% Riemann-Liouville Fractional Derivative (RLFD) using Finite Difference
% and Gaussian Quadrature.

b1 = t;
b2 = t-dt;
a = t0;

% define kernels
ker1 = @(x) f(x).*(b1-x).^(-alpha);
ker2 = @(x) f(x).*(b2-x).^(-alpha);

% user inputs
input1 = struct('b',b1,'a',a);
input2 = struct('b',b2,'a',a);

% evaluate integral using gaussian quadrature
[int1,settings1] = sinc_quad(ker1,M,input1);
[int2,settings2] = sinc_quad(ker2,M,input2);

dalphadt = 1/(dt*gamma(1-alpha))*(int1 - int2);

% Debug
out.int1 = int1;
out.int2 = int2;
out.settings1 = settings1;
out.settings2 = settings2;