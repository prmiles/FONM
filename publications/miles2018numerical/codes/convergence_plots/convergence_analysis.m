% Run convergence analysis/comparison

% setup workspace
clear; close all; clc;

% add path to data files
addpath(strcat('data',filesep,'exponential'));
addpath(strcat('data',filesep,'trig'));

% read in results files
% files = {'glag', 'gl', 'gq', 'sq', 'rs'};
files = {'gl', 'rs', 'gq', 'glag'};
nf = length(files);
for ii = 1:nf
    res.(files{ii}).expo = load(strcat(files{ii},'_conv_expo.mat'));
    res.(files{ii}).trig = load(strcat(files{ii},'_conv_trig.mat'));
end

% plot style
res.rs.pltsty = {'g-.', 'RS'};
res.glag.pltsty = {'r:', 'GLQ'};
res.gq.pltsty = {'--b', 'GQ'};
res.sq.pltsty = {'-k', 'Sinc'};
res.gl.pltsty = {'om', 'GL'};

% plot convergence for exponential example
% subplot_settings;
sbs.plotwidth = 3.25;
sbs.plotheight = 2.75;
sbs.margin = [0.85, 0.2, 0.75, 0.15]; % [Left, Right, Bottom, Top]
sbs.nbcol = 2;
sbs.nbrow = 1;
sbs.spacecol = 0.75;
sbs.spacerow = 0.5;

positions = subplot_pos(sbs);

set_figure_dimensions(sbs.plotwidth, sbs.plotheight);

maxN = 500;
legstr = cell(nf,1);
for ii = 1:nf
%     subplot('position',positions{1})
    figure(1)
    set_figure_dimensions(sbs.plotwidth, sbs.plotheight);
    x = res.(files{ii}).expo.store_results.N;
    y = res.(files{ii}).expo.store_results.relative_error;
    psty = res.(files{ii}).pltsty{1};
    if ii == 1
        loglog(x(x<maxN),y(1:sum(x<maxN)),psty, 'LineWidth', 2, 'MarkerSize', 10);
    else
        hold on
        loglog(x(x<maxN),y(1:sum(x<maxN)),psty, 'LineWidth', 2, 'MarkerSize', 10);
        hold off
    end
    
%     subplot('position',positions{2})
    figure(2)
    set_figure_dimensions(sbs.plotwidth, sbs.plotheight);
    x = res.(files{ii}).trig.store_results.N(1,:);
    y = res.(files{ii}).trig.store_results.relative_error(1,:);
    psty = res.(files{ii}).pltsty{1};
    if ii == 1
        loglog(x(x<maxN),y(1:sum(x<maxN)),psty, 'LineWidth', 2, 'MarkerSize', 10);
    else
        hold on
        loglog(x(x<maxN),y(1:sum(x<maxN)),psty, 'LineWidth', 2, 'MarkerSize', 10);
        hold off
    end
    legstr{ii} = res.(files{ii}).pltsty{2};
end
% subplot('position',positions{1})


for ii = 1:2
%     subplot('position',positions{ii})
    figure(ii)
    set(gca, 'FontSize', 15);
    xlabel('N', 'FontSize', 15);
    xlim([0, maxN]);
    
    legh = legend(legstr,'Location','SouthEast');
legend boxoff
set(legh, 'FontSize', 10);

ylabel('Rel. Error (-)', 'FontSize', 15);
end

% compare CPU time
for ii = 1:nf
    fprintf('Method: %5s\n', files{ii});
    N = res.(files{ii}).expo.store_results.N(1,:);
    ct = res.(files{ii}).expo.store_results.calctime(1,:);
    for jj = 1:length(N)
        fprintf('\t%i,\t%5.2e\n', N(jj),ct(jj)); 
    end
end

