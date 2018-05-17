function [sigma, G, calctime] = run_GL(npar, time, lambda)

% --------------------------------------------------------
% Hyperelastic Stress
[sfunc, dsdx] = nonaffine_hyperelastic_stress_function(npar);
sigma.hyperelastic = sfunc(lambda(time))';
stretch = lambda(time)';
% --------------------------------------------------------
% Viscoelastic Stress
tic
[sigma.viscoelastic, G] = GL_nonlinear_visco(npar, ...
    time, sfunc, dsdx, lambda);
calctime = toc;
% --------------------------------------------------------
% Nominal stress
sigma.total = sigma.hyperelastic + sigma.viscoelastic;

save('GL_results', 'sigma', 'stretch', 'time', 'G', 'calctime');
