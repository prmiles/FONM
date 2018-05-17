function [q, G] = GQRS_nonlinear_visco(npar, time, sfunc, dsdx, lambda)

% -------------------------------------------------------------------------
% Viscoelastic Stress
% Parameters
eta = npar.eta;
alpha = npar.alpha;
gamma11 = npar.gamma11;
beta = npar.beta;

f = @(t) sfunc(lambda(double(t)));
% f = @(t) sfunc(lambda(t));
% Break integration into two steps
% 1. Gaussian quadrature from [a,b-bT]
% define kernel for gaussian-quadrature
kerQG = @(x,bb) f(x).*(bb-x).^(-alpha);
NGQ = 5;
gpts = base_gauss_points;
a = time(1);
bTfunc = @(aa,bb) 0.05*(bb-aa);

bTvec = bTfunc(a, time);
dxGQvec = (time - bTvec - a)./(NGQ - 1);
xGQmat = interval_gauss_points(gpts, NGQ-1, dxGQvec, a);
wGQmat = gauss_weights(NGQ-1, dxGQvec);

dt = 1e-4;
nt = length(time);
G = zeros(nt,1);
parfor ii = 2:nt
    b = time(ii);
    % evaluate integral using gaussian quadrature
    int1GQ = sum(wGQmat(:,ii).*kerQG(xGQmat(:,ii),b));
    int2GQ = sum(wGQmat(:,ii).*kerQG(xGQmat(:,ii),b-dt));
    
    % 2. Perform Riemann-Sum from [b-bT,b]
    int1RS = riemann_sum_RL_FD(f, linspace(b-bTvec(ii), b, 15), alpha);
    int2RS = riemann_sum_RL_FD(f, linspace(b-bTvec(ii), b-dt, 15), alpha);
   
    % add contributions
    int1 = int1GQ + int1RS;
    int2 = int2GQ + int2RS;
    
    G(ii) = 1/(dt*gamma(1-alpha))*(int1 - int2);
end

% Viscoelastic stress
hyperelastic_stress = sfunc(lambda(time))';
dhypdx = dsdx(lambda(time))';
q = beta*(hyperelastic_stress...
    - (1./gamma11).*(dhypdx).*(...
    beta.*hyperelastic_stress-eta*G(:)));

q = q(:); % (kPa)
end
