function [sigma] = fractional_order_caputo_linear_viscoelastic_stress(npar, ...
    time, stretch)

% unpack model parameters
eta = npar.eta;
alpha = npar.alpha;

% Find switch time and assign speeds
dL_dt = (stretch-[1;stretch(1:end-1)])./(time-[1;time(1:end-1)]);
dL_dt(isnan(dL_dt)) = 0;
switch_ind = find(dL_dt < 0); switch_ind = switch_ind(1);
tc = time(switch_ind); % transition time for loading to unloading
u1 = dL_dt(1:switch_ind-1); 
u2 = dL_dt(switch_ind:end);
u1 = mean(u1); % speed during loading
u2 = mean(u2); % speed during relaxation

nt = length(stretch);
sigma = zeros(nt,1); % initialize array

% The model below is derived using the Caputo definition for fractional
% derivatives.  As we assume the rate of deformation during loading and
% relaxing is constant, we break the analysis into two steps.  As the rate
% is constant (df(t)/dt = constant), one can easily solve the Caputo
% fractional derivative analytically.  This results in an explicity power law
% function for the viscoelastic stress.

% calculates stress during loading
% alpha - fractional order
% tc - critical time, switch from loading to relaxing
% u1 - speed during loading
% u2 - speed during relaxing
% t  - time vector
clear t
t = time(1:switch_ind);
sigma(1:switch_ind) = eta*(u1*t.^(1-alpha))./(gamma(1-alpha)*(1-alpha));

% calculate stress during unloading
% alpha - fractional order
% tc - critical time, switch from loading to relaxing
% u1 - speed during loading
% u2 - speed during relaxing
% t  - time vector
clear t
t = time(switch_ind+1:nt);
sigma(switch_ind+1:nt) = eta*(-u1*((t-tc).^(1-alpha) - t.^(1-alpha)))./(gamma(1-alpha)*(1-alpha)) ...
    + eta*((-u2).*(-(t-tc).^(1-alpha))./(gamma(1-alpha)*(1-alpha)));
% sigma(switch_ind+1:nt) = ...
%     eta*(-u1.*((t-tc).^(1-alpha)-t.^(1-alpha))./(gamma(1-alpha).*(1-alpha))...
%     +(-u2).*(-(t-tc).^(1-alpha))./(gamma(1-alpha)*(1-alpha)));