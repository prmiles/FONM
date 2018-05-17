function [s, dsdx] = nonaffine_hyperelastic_stress_function(npar)

% unpack model parameters
Gc = npar.Gc; % (kPa) - crosslink modulus
Ge = npar.Ge; % (kPa) - entanglement modulus
lam_max = npar.lam_max; % (-) - maximum extension of affine tube

I1 = @(x) x.^2 + 2./x;
dI1dx = @(x) 2.*x - 2./x.^2;

s = @(x) ...
    Gc./6.*dI1dx(x).*(9.*lam_max.^2 - I1(x))./(3.*lam_max.^2 - I1(x)) ...
    + Ge.*(1 + x.^(-1/2) - x.^(-2) - x.^(-3/2));

dsdx = @(x) Gc/6*((2+4.*x.^(-3)).*(9*lam_max.^2-I1(x))./(3*lam_max.^2-I1(x)) ...
    + (2.*x-2./x.^2).*(6*lam_max.^2./(3*lam_max.^2 - I1(x)).^2).*(2.*x-2./x.^2)) ...
    + Ge.*(-1/2.*x.^(-3/2) + 2.*x.^(-3) + 3/2.*x.^(-5/2));