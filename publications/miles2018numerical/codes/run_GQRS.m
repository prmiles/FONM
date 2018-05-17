function [sigma, G, calctime] = run_GQRS(npar, time, lambda)

% --------------------------------------------------------
% Hyperelastic Stress
[sfunc, dsdx] = nonaffine_hyperelastic_stress_function(npar);
sigma.hyperelastic = sfunc(lambda(time))';
stretch = lambda(time)';
% --------------------------------------------------------
% Viscoelastic Stress
tic;
[sigma.viscoelastic, G] = GQRS_nonlinear_visco(npar, ...
    time, sfunc, dsdx, lambda);
calctime = toc;
% --------------------------------------------------------
% Nominal stress
sigma.total = sigma.hyperelastic + sigma.viscoelastic;

save('GQRS_results', 'sigma', 'stretch', 'time', 'G', 'calctime');
