function [q, G] = GQGL_nonlinear_visco(npar, time, sfunc, dsdx, lambda)

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
% 2. Gauss-Laguerre quadrature from [b-bT, b]
% define kernel
kerGL = @(x,aa,bb) (bb-aa)^(1-alpha).*f((bb-aa).*x + aa).*(1-x).^(-alpha);
% define Gauss-Laguerre points and weights
NGL = 16;
[xGL, wGL] = GaussLaguerre_2(NGL, 0, 2);

dt = 1e-6;
nt = length(time);
G = zeros(nt,1);
parfor ii = 2:nt
    b = time(ii);
    % 1. evaluate integral using gaussian quadrature
    int1GQ = sum(wGQmat(:,ii).*kerQG(xGQmat(:,ii),b));
    int2GQ = sum(wGQmat(:,ii).*kerQG(xGQmat(:,ii),b-dt));
    
    % 2. Perform Gauss-Laguerre quadrature form [b-bT,b]
    % evaluate integral using gauss-laguerre quadrature
    int1GL = sum(wGL.*kerGL(1-exp(-xGL), b-bTvec(ii), b));
    int2GL = sum(wGL.*kerGL(1-exp(-xGL), b-bTvec(ii), b-dt));
    
    int1 = int1GQ + int1GL;
    int2 = int2GQ + int2GL;
    
    G(ii) = 1/(dt*gamma(1-alpha))*(int1 - int2);
end

% Viscoelastic stress
shyp = sfunc(lambda(time))';
dshyp = dsdx(lambda(time))';
q = beta*(shyp)...
    - (1./gamma11).*(dshyp).*(...
    beta.*shyp-eta*G(:));

q = q(:); % (kPa)
end
