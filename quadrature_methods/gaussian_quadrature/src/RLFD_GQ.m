function [dalphadt, int1, int2] = RLFD_GQ(f, alpha, N, dt, a, b)

% define kernel for gaussian-quadrature
ker = @(x,bb) f(x).*(bb-x).^(-alpha);

% define grid for gaussian quadrature
dx1 = (b - a)/(N - 1);
dx2 = (b - dt - a)/(N - 1);

% create gauss points & weights
x1 = gauss_points(N-1, dx1, a);
w1 = gauss_weights(N-1, dx1);

x2 = gauss_points(N-1, dx2, a);
w2 = gauss_weights(N-1, dx2);

% evaluate integral using gaussian quadrature
int1 = sum(w1.*ker(x1,b));
int2 = sum(w2.*ker(x2,b-dt));

dalphadt = 1/(dt*gamma(1-alpha))*(int1 - int2);

end