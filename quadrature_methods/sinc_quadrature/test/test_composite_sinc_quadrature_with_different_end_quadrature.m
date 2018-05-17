% setup workspace
clear; close all; clc;

% add path to sinc quadrature source code
dpaths.pathtosrc = '../src/';
dpaths.utilities = '../../../utilities/matrix_to_latex_table/';
fld = fields(dpaths);
for ii = 1:length(fld)
    addpath(dpaths.(fld{ii}));
end

% define test problem
f = @(x)(1-x).^(-.9).*exp(2*x); %1./x.^(0.7); %2*x*1i + 2;
correct_answer = 65.2162;
t0 = 0;
t = 1;
% f = @(x)(x).^(0.9); %1./x.^(0.7); %2*x*1i + 2;
% correct_answer = 0.526316; % Wolfram Alpha
% t0 = 0;
% t = 1;

% break [a,b] into subintervals - make subintervals towards b smaller
a = t0;
b = t;

bsinc = t - 1e-8;

% ndivs = 8;
% gpoints = [0,1-2.^-(1:ndivs),t];
nint = 51; %21;
intervals = zeros(nint,3);
h = zeros(nint,1);
for kk = 1:nint
    if kk == 1
        intervals(kk,1) = a;
    else
        intervals(kk,1) = intervals(kk-1,2);
    end
    
    h(kk) = (bsinc-intervals(kk,1))/2; % divide remaining interval in half
    
    if kk == nint
        intervals(kk,2) = bsinc; % finish interval
    else
        intervals(kk,2) = intervals(kk,1) + h(kk); 
    end
    
    % add lower grid limit for each composite
    if kk < nint/4
        intervals(kk,3) = 20;
    elseif nint/4 < kk && kk < nint/2
        intervals(kk,3) = 40;
    else
        intervals(kk,3) = 80;
    end
%     intervals(kk,3) = M*kk.*1;
    
end

% perform sinc quadrature on interval [a, bsinc]
Tint = zeros(nint,1);
for kk = 1:nint
    M = intervals(kk,3);
    
    inputsettings.a = intervals(kk,1);
    inputsettings.b = intervals(kk,2);
    inputsettings.alpha = 1;
    inputsettings.beta = 1;
    inputsettings.d = pi/2;
        
    [Tint(kk), settings(kk)] = sinc_quad(f,M,inputsettings);
end

% perform midpoint quadrature on remaining interval [bsinc, b]
Tint(kk+1) = (b - bsinc)*f((bsinc + b)/2);

% Display interval contributions
T = sum(Tint);
fprintf('T = %4.4f, Correct Answer = %4.4f\n', T, correct_answer);
fprintf('Interval contribution:\n');
fprintf('(%3s,%3s)\t%8s\t%8s\t%10s\t%10s\t%10s\n', 'i', 'M', 'Left', 'Right', 'I_LR', 'I_CLR', 'h');
CTint = zeros(nint+1,1);
for kk = 1:nint+1
    CTint(kk) = sum(Tint(1:kk));
    if kk < nint + 1
        fprintf('(%3i,%3i)\t%8.6e\t%8.6e\t%10.5f\t%10.5f\t%10.5e\n', kk,intervals(kk,3), intervals(kk,1), intervals(kk,2), Tint(kk), CTint(kk), settings(kk).h)
    else
        fprintf('(%3i)\t%10.5f\t%10.5f\n', kk, Tint(kk), CTint(kk))
    end
end

% plot nodes
for kk = 1:nint
    hold on
    plot(settings(kk).nodes, settings(kk).weights.*f(settings(kk).nodes))
    hold off
end

% Create matrix for tabling
intdisp = 1:2:kk;
mtx = [intdisp', intervals(intdisp,3), intervals(intdisp,1:2), Tint(intdisp), CTint(intdisp)];
table_settings.number_type = {'%i','%i','%4.5e','%4.5e','%4.5f','%4.5f'};
table_settings.outputformat = {'cmd_window'};
table_settings = mtx_to_latex_table(mtx, table_settings);

% % plot grid
% figure(2)
% hold on
% for kk = 1:nint
%    nodes = settings(kk).nodes;
%    plot(nodes, zeros(size(nodes)), '.b', 'MarkerSize', 15);
%    plot(intervals(kk,1), 0, 'og', 'MarkerSize', 10, 'LineWidth', 2);
%    plot(intervals(kk,2), 0, 'og', 'MarkerSize', 10);
%    xtickstr{kk} = sprintf('x_{%i}',kk-1);
% end
% plot([bsinc, b], [0,0], 'sr', 'Markersize', 12, 'LineWidth', 2);
% xlim([-0.05,1.05])
% set(gca, 'YTickLabel', [])
% set(gca, 'XTick', [intervals(1:end,1)', intervals(end,2), b]);
% xtickstr{1} = strcat('a=',xtickstr{1});
% xtickstr{end+1} = sprintf('x_{%i}',nint);
% xtickstr{end+1} = sprintf('x_{%i}=b',nint+1);
% set(gca, 'XTickLabel', xtickstr, 'FontSize', 15);
%    hold off
   
% remove path to source
for ii = 1:length(fld)
    rmpath(dpaths.(fld{ii}));
end