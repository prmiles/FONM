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
f = @(x)(1-x).^(-.9).*exp(2*x);
correct_answer = 65.2162;
t0 = 0;
t = 1;

% break [a,b] into subintervals - make subintervals towards b smaller
a = t0;
b = t-eps;

nint = 60; %21;
intervals = vpa(zeros(nint,3),2);
h = zeros(nint,1);
for kk = 1:nint
    if kk == 1
        intervals(kk,1) = a;
    else
        intervals(kk,1) = intervals(kk-1,2);
    end
    
    h(kk) = vpa((b-intervals(kk,1))/2,16); % divide remaining interval in half
    
    if kk == nint
        intervals(kk,2) = b; % finish interval
    else
        intervals(kk,2) = intervals(kk,1) + h(kk); 
    end
    
    % add lower grid limit for each composite
    intervals(kk,3) = 20;
    
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
    inputsettings.precision = 16;
    
    [Tint(kk), settings(kk)] = sinc_quad_with_extended_precision(f,M,inputsettings);
end

% Display interval contributions
T = sum(Tint);
fprintf('T = %4.4f, Correct Answer = %4.4f\n', T, correct_answer);
fprintf('Interval contribution:\n');
fprintf('(%3s,%3s)\t%8s\t%8s\t%10s\t%10s\t%10s\n', 'i', 'M', 'Left', 'Right', 'I_LR', 'I_CLR', 'h');
CTint = zeros(nint+1,1);
for kk = 1:nint
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

% % Create matrix for tabling
% intdisp = 1:2:kk;
% mtx = [intdisp', intervals(intdisp,3), intervals(intdisp,1:2), Tint(intdisp), CTint(intdisp)];
% table_settings.number_type = {'%i','%i','%4.5e','%4.5e','%4.5f','%4.5f'};
% table_settings.outputformat = {'cmd_window'};
% table_settings = mtx_to_latex_table(mtx, table_settings);
   
% remove path to source
for ii = 1:length(fld)
%     rmpath(dpaths.(fld{ii}));
end