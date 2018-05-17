% setup workspace
clear; close all; clc;

addpath('../src');

% ---------------------------------
% Define test function
% % alpha = 0.9
% a = 2;
% f = @(x) exp(a*x);
% exact_value = 102.082;
% alpha = 0.9; % order of FD
% t0 = 1; % fiducial point
% t = 2; % point of evaluation

a = 2;
f = @(x) exp(a*x);
exact_value = 13.815;
alpha = 0.9; % order of FD
t0 = 0; % fiducial point
t = 1; % point of evaluation
outfile = 'gl_conv_expo';

% a = -2;
% f = @(x) exp(a*x);
% exact_value = -0.277119;
% alpha = 0.9; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% f = @(x) cos(2*x);
% exact_value = -1.77858;
% alpha = 0.9; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation
% outfile = 'gl_conv_trig';

% f = @(x) x.^2 - x + 1;
% exact_value = 0.965135;
% alpha = 0.9; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% ---------------------
% alpha = 0.1
% a = 2;
% f = @(x) exp(a*x);
% exact_value = 7.95224;
% alpha = 0.1; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% a = -2;
% f = @(x) exp(a*x);
% exact_value = 0.076243;
% alpha = 0.1; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% f = @(x) x.^2 - x + 1;
% exact_value = 0.990503;
% alpha = 0.1; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% f = @(x) cos(2*x);
% exact_value = -0.578611;
% alpha = 0.1; % order of FD
% t0 = 0; % fiducial point
% t = 1; % point of evaluation

% settings
Ns = [8, 16, 24, 32, 64, 128, 256]; %, 6000, 6e5]; % # of sample points

n = ceil(alpha); % smallest integer > alpha
% complex step sizes to test
hs = 1e-5; %[1-eps, 1e-1, 1e-2, 1e-5];
% hs = [1-eps, 1e-1, 1e-2, 1e-5];
% Loop through step sizes
for nn = 1:length(Ns)
    N = Ns(nn);
    fprintf('N = %i\n', N);
    for ii = 1:length(hs)
        dt = (t-t0)/(N-1);
        tic
        [computed_value] = RLFD_GL(f, alpha, N, t, dt);
        calctime = toc;
        % Compute relative error
        relative_error = abs((exact_value - computed_value)/exact_value);
        
        fprintf('dt = %4.3e:\t relative error = %4.2e, vc = %4.3f\n', ...
            dt, relative_error, computed_value)
        
        store_results.relative_error(ii, nn) = relative_error;
        store_results.computed_value(ii, nn) = computed_value;
        store_results.N(ii,nn) = N;
        store_results.h(ii,nn) = dt;
        store_results.calctime(ii,nn) = calctime;
    end
    legstr{nn} = sprintf('N = %s',num2str(Ns(nn)));
end

save(outfile, 'store_results');

loglog(store_results.N, store_results.relative_error, 's-');
% legend(legstr)
xlabel('N','FontSize', 22);
ylabel('Relative Error', 'FontSize', 22);
set(gca, 'FontSize', 22);

for ii = 1:length(hs)
    fprintf('%4.2e\t', hs(ii));
    for nn = 1:length(Ns)
        fprintf('& %4.5f', store_results.computed_value(ii,nn));
    end
    fprintf('\\\\ \n');
end

% for nn = 1:length(Ns)
%     for ii = 4
%         fprintf('%2i\t', Ns(nn));
%         fprintf('& %4.5f & %4.2e', store_results.computed_value(ii,nn), store_results.relative_error(ii,nn));
%     end
%     fprintf('\\\\ \n');
% end