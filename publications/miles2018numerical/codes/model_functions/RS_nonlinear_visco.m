function [q, G] = RS_nonlinear_visco(npar, time, sfunc, dsdx, lambda)

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

G = zeros(length(time),1);
parfor ii = 2:length(time)
    G(ii) = fd_rlfd_function(f, time(1:ii), alpha);
end

% Viscoelastic stress
q = beta*(hyperelastic_stress...
    - (1./gamma11).*(derivative_hyperelastic_stress).*(...
    beta.*hyperelastic_stress-eta*G(:)));

q = q(:); % (kPa)
end
