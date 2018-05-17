function [total_hyperelastic_stress, sigma, sigmaprime] = ...
    nonaffine_hyperelastic_stress(npar, stretch)

% unpack model parameters
Gc = npar.Gc; % (kPa) - crosslink modulus
Ge = npar.Ge; % (kPa) - entanglement modulus
lam_max = npar.lam_max; % (-) - maximum extension of affine tube

% First Stretch Invariant:
% - assumes incompressibility and uniform deformation in x_2 and x_3-dir.
I1 = stretch.^2 + 2./stretch;

% Hydrostatic pressure 
% - Lagrange multiplier - BC: \sigma_{22} = \sigma_{33} = 0
sigma.hyd_press.crosslink = ...
    (Gc/3./stretch.*((9*lam_max^2 - I1)./(3*lam_max^2 - I1)));
sigma.hyd_press.entanglement = Ge./stretch.^0.5.*(1 - stretch);

% Hyperelastic stress (assuming principal direction)
sigma.crosslink = ...
    1./3.*Gc.*stretch.*((9*lam_max^2 - I1)./(3*lam_max^2 - I1));
sigma.entanglement = Ge.*(1-1./stretch.^2);

% Calculate the derivative of the hydrostatic pressure wrt stretch
sigmaprime.hyd_press.crosslink = 2*Gc/3*((6*lam_max.^2)./((3*lam_max.^2 - I1).^2));
sigmaprime.hyd_press.entanglement = Ge*(-0.5.*stretch.^(-1.5)-0.5.*stretch.^(-0.5))./stretch;

% Calculate second derivative of hyperelastic free energy wrt stretch
sigmaprime.crosslink = Gc/3*((9*lam_max.^2-I1)./(3*lam_max.^2 - I1))+...
2/3*Gc.*stretch.^2.*((6*lam_max.^2)./((3*lam_max.^2 - I1).^2));
sigmaprime.entanglement = 2*Ge./(stretch.^3);

% Calculate hyperelastic stress in light of hydrostatic pressure
sigma.total = sigma.crosslink + sigma.entanglement ...
    - (sigma.hyd_press.crosslink + sigma.hyd_press.entanglement)./stretch;

% Calculate the derivative of the nominal hyperelastic stress wrt stretch
sigmaprime.total = sigmaprime.crosslink + sigmaprime.entanglement ...
    + (sigma.hyd_press.crosslink + sigma.hyd_press.entanglement)./stretch ...
    - (sigmaprime.hyd_press.crosslink + sigmaprime.hyd_press.entanglement)./stretch;

total_hyperelastic_stress = sigma.total;