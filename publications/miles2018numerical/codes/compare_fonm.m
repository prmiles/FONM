% compare fractional order linear viscoelasticity
close all; clear; clc;

addpath('results_files');

res.RS = load('RS_results.mat');
res.GL = load('GL_results.mat');
res.GQGL = load('GQGL_results.mat');
res.GQRS = load('GQRS_results.mat');

% plot style
res.RS.pltsty = {'g-.', 'RS'};
res.GL.pltsty = {'r:', 'GL'};
res.GQGL.pltsty = {'--b', 'GQGL'};
res.GQRS.pltsty = {'--k', 'GQRS'};

flds = sort(fields(res));
nf = length(flds);
% plot G
hold on
legstr = cell(nf,1);
for ii = 1:nf
    plot(res.(flds{ii}).time, res.(flds{ii}).G, res.(flds{ii}).pltsty{1}, 'LineWidth',2);
    legstr{ii} = res.(flds{ii}).pltsty{2};
end
hold off
legend(legstr, 'Location', 'NorthEast');
legend('boxoff')
set(gca, 'FontSize', 15);

xlabel('Time', 'FontSize', 15);
% ylabel('Viscoelastic Stress', 'FontSize', 15);
ylabel('G', 'FontSize', 15);

box on

set_figure_dimensions(6,4);

fn = 'fo_nonlinear_visco_comparison_';
% alphastr = input('alpha description:','s');
% fn = strcat(fn,alphastr);
% save_figure(fn, gcf, {'fig'; 'png'; 'eps'}, 1);
figure
hold on
legstr = cell(nf,1);
for ii = 1:nf
    plot(res.(flds{ii}).time, res.(flds{ii}).sigma.viscoelastic, res.(flds{ii}).pltsty{1}, 'LineWidth',2);
    legstr{ii} = res.(flds{ii}).pltsty{2};
end
hold off
legend(legstr, 'Location', 'NorthEast');
legend('boxoff')
set(gca, 'FontSize', 15);

xlabel('Time', 'FontSize', 15);
ylabel('Viscoelastic Stress', 'FontSize', 15);
% ylabel('G', 'FontSize', 15);

% Display error metrics
fprintf('Assume Grunwald-Letnikov (GL) is true solution\nCompare with:\n');
fprintf('\tGQGL: Gaussian quadrature, Gauss-Laguerre\n');
fprintf('\tRS: Riemann Sum\n');
fprintf('\tGQRS: Gaussian quadrature, Riemann Sum\n');
for ii = 1:nf
    % need to interpolate GL to same spots on QoI
    [viscoTrue] = interp1(res.GL.time, res.GL.G, res.(flds{ii}).time(:));
    res.(flds{ii}).L2 = norm(viscoTrue - res.(flds{ii}).G, 2);
    res.(flds{ii}).error = sum(abs(viscoTrue - res.(flds{ii}).G))/length(viscoTrue);
end
fprintf('%10s\t%10s\t%10s\t%10s\n','Method', 'L2-norm', 'Rel-Err', 'CPU-Time');
for ii = 1:nf
    fprintf('%10s\t%10.2e\t%10.2e\t%10.4f\n',flds{ii}, res.(flds{ii}).L2, res.(flds{ii}).error, res.(flds{ii}).calctime);
end


% % subplot_settings;
% subplot_settings.plotwidth = 15;
% subplot_settings.plotheight = 3;
% subplot_settings.margin = [0.65, 0.2, 0.5, 0.15]; % [Left, Right, Bottom, Top]
% subplot_settings.nbcol = 4;
% subplot_settings.nbrow = 1;
% subplot_settings.spacecol = 0.55;
% subplot_settings.spacerow = 0.5;
% 
% if make.stress_plot == 1
%     [~, h] = plot_stress_objects(pdata,'sigma',subplot_settings);
% end
