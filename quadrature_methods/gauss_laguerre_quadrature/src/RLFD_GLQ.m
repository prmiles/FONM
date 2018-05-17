function [dalphadt, int1, int2] = RLFD_GLQ(f, alpha, N, dt, a, b)

% define Gauss-Laguerre points and weights
[x1, w1] = GaussLaguerre_2(N, 0, 2);

% define kernel
% ker1 = @(x,y) f(x).*(y-x).^(-alpha);
% ker2 = @(x,y) y.*f(y*x).*(y-y*x).^(-alpha);
ker = @(x,a,b) (b-a)^(1-alpha).*f((b-a).*x + a).*(1-x).^(-alpha);

% % evaluate integral using gaussian quadrature
int1 = sum(w1.*ker(1-exp(-x1), a, b));
int2 = sum(w1.*ker(1-exp(-x1), a, b-dt));

dalphadt = 1/(dt*gamma(1-alpha))*(int1 - int2);