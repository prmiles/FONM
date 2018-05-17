function [dalphadt] = rlfd_gauss_laguerre_data(sfunc, lambda, alpha, t, dt, x1, w1)

% define kernel
% ker1 = @(x,y) f(x).*(y-x).^(-alpha);
ker2 = @(x,y) y.*sfunc(lambda(y.*x)).*(y-y.*x).^(-alpha);

% % evaluate integral using gaussian quadrature
int1 = sum(w1.*ker2(double(1-exp(-x1)),t));
int2 = sum(w1.*ker2(double(1-exp(-x1)),t - dt + eps));

dalphadt = 1/((dt)*gamma(1-alpha))*(int1 - int2);