clear; close all; clc;

f = @(x) 1./x.^(0.7); %2*x*1i + 2;
t0 = 0;
t = 1;
N = 10000;

% define grid
gridpoints = linspace(t0, real(t), N);

dt = gridpoints(2) - gridpoints(1);

% create gauss points & weights
gpoints = gauss_points(N-1, dt, t0);
gweights = gauss_weights(N-1, dt);

topofinterval = repelem(gridpoints(2:end),4);
topofinterval = topofinterval(:);

gauss_function = @(x, y) f(x);

% evaluate integral using gaussian quadrature
tmp = sum(gweights.*gauss_function(gpoints, topofinterval))