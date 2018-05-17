function [q, G] = GL_nonlinear_visco(npar, time, sfunc, dsdx, lambda)

hyperelastic_stress = sfunc(lambda(time))';
derivative_hyperelastic_stress = dsdx(lambda(time))';
% -------------------------------------------------------------------------
% Viscoelastic Stress
% Parameters
eta = npar.eta;
alpha = npar.alpha;
gamma11 = npar.gamma11;
beta = npar.beta;

f = @(t) sfunc(lambda(double(t)));

% Create symbolic variable
N = length(time);

m = vpa(0:1:N-1,8);
coef = (-1).^m.*gamma(alpha+1)./((gamma(alpha-m+1)).*(gamma(m+1)));
coef = double(coef);
% m = double(m);
h = time(2) - time(1);
G = zeros(N,1);
parfor ii = 2:N    
    G(ii) = GL_fractional_derivative(alpha, f, time(ii), coef, h, m, ii);
end

% Viscoelastic stress
q = beta*(hyperelastic_stress...
    - (1./gamma11).*(derivative_hyperelastic_stress).*(beta.*hyperelastic_stress-eta*G(:)));

q = q(:); % (kPa)
end
