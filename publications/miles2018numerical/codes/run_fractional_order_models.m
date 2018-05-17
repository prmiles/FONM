% main script

% setup workspace
clear; close all; clc;

% add paths
addpath('matlab_functions');
addpath('model_functions');

% create results directory
make_directory('results_files');

% define plot
make.stress_plot = 1;

save_plot = 1;

% generate data
ndp = 100; % # of data points
ts = 5/0.67;%vpa(8,2);
tf = 2*ts;%vpa(16,2);
u1 = 0.67;
u2 = -0.67;
% lambda = @(t) @(t) 1 + (t<ts).*t*u1 + (t>=ts).*(((t-ts)*u2) + ts*u1); %stretch_function(t, ts, tf, u1, u2);
lambda = @(x) interp1([0-sqrt(eps), ts, tf+sqrt(eps)], [1, 6, 1],x,'linear');
time = linspace(0,ts,ndp);
time = [time, time(2:end) + ts];
stretch = lambda(time);

% define parameter space
npar.Gc = 11.9; % (kPa)
npar.Ge = 4.47; % (kPa)
npar.lam_max = 8.50; % (-)
npar.eta = 2.32; % (kPa*s)
npar.alpha = 0.9;%[0.1, 0.2, 0.5]; % (-) fractional order
npar.gamma11 = 14.0;
npar.beta = 0.89;

% Run Grunwald-Letnikov
[GL.sigma, GL.G, GL.calctime] = run_GL(npar, time, lambda);

% Run Gaussian-Quadrature with Riemann Sum
[GQRS.sigma, GQRS.G, GQRS.calctime] = run_GQRS(npar, time, lambda);

% Run Gaussian-Quadrature with Gauss-Laguerre
[GQGL.sigma, GQGL.G, GQGL.calctime] = run_GQGL(npar, time, lambda);

% Run Riemann Sum
[RS.sigma, RS.G, RS.calctime] = run_RS(npar, time, lambda);

% move results files to folder
files = Extract_Files('.mat');
for ii = 1:length(files)
    move_files(files{ii}(1:end-4), 'results_files', {'.mat'});
end

% Display error metrics
fprintf('Assume Grunwald-Letnikov (GL) is true solution\nCompare with:\n');
fprintf('\tGQGL: Gaussian quadrature, Gauss-Laguerre\n');
fprintf('\tRS: Riemann Sum\n');
fprintf('\tGQRS: Gaussian quadrature, Riemann Sum\n');
res.GL = GL;
res.GQRS = GQRS;
res.GQGL = GQGL;
res.RS = RS;
flds = sort(fields(res));
nf = length(flds);
for ii = 1:nf
    % need to interpolate GL to same spots on QoI
    [viscoTrue] = res.GL.sigma.viscoelastic;
    res.(flds{ii}).L2 = norm(viscoTrue - res.(flds{ii}).sigma.viscoelastic, 2);
    res.(flds{ii}).error = sum(abs(viscoTrue - res.(flds{ii}).sigma.viscoelastic))/length(viscoTrue);
end
fprintf('%10s\t%10s\t%10s\t%10s\n','Method', 'L2-norm', 'Rel-Err', 'CPU-Time');
for ii = 1:nf
    fprintf('%10s\t%10.2e\t%10.2e\t%10.4f\n',flds{ii}, res.(flds{ii}).L2, res.(flds{ii}).error, res.(flds{ii}).calctime);
end