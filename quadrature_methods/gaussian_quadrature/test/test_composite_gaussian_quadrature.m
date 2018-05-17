% Riemann-Liouville Fractional Derivative (RLFD) using Finite Difference
% (FD) and Gaussian Quadrature (GQ)

% setup workspace
clear; close all; clc;

% Define test problem
alpha = 0.9;
f = @(x,y)(y-x).^(-alpha).*exp(2*x);
correct_answer = 65.2162;

% f = @(x) x.^0.5;
% correct_answer = 2/3;


N = 32;
a = 0;
b = 1;
precision = 0;

% perform sinc quadrature on interval [a, bsinc]
Tint = zeros(N,1);
for kk = 1:N
    if kk == 1
        ai = a;
    else
        ai = bi;
    end
    
    if kk > N - 2
        h = vpa((b-ai)/2,2); % divide remaining interval in half
    else
        h = (b-ai)/2; % divide remaining interval in half
    end
    
    if kk == N
        bi = b; % finish interval
    else
        bi = ai + h; 
    end
    
    % add lower grid limit for each composite
    if kk < N/1.5 % nodes per intervals
        n = 4; precision = 0;
    elseif kk < N/1.1
        n = 4; precision = 2;
    else
        n = 16; precision = 16;
    end    
    
    inputsettings.a = ai;
    inputsettings.b = bi;
    inputsettings.n = n;
    inputsettings.precision = precision;
    
    g = @(x) f(x,b);
    
    fprintf('Integrating interval %i of %i\n',kk,N);
    [Tint(kk), settings(kk)] = composite_guassian_quadrature(g,inputsettings);
end

% Display interval contributions
T = sum(Tint(isfinite(Tint)));
fprintf('T = %4.4f, Correct Answer = %4.4f\n', T, correct_answer);
fprintf('Interval contribution:\n');
fprintf('(%3s,%3s)\t%8s\t%8s\t%10s\t%10s\t%10s\n', 'i', 'M', 'Left', 'Right', 'I_LR', 'I_CLR', 'h');
CTint = zeros(N,1);
for kk = 1:N
    CTint(kk) = sum(Tint(1:kk));
    fprintf('(%3i,%3i)\t%8.6e\t%8.6e\t%10.5f\t%10.5f\n', kk,settings(kk).n, settings(kk).a, settings(kk).b, Tint(kk), CTint(kk))
end

% plot first interval and kernel
out = settings(end-1);
plot(out.gpoints,zeros(size(out.gpoints)), 'xb')
hold on
plot(out.gpoints,out.kernel(out.gpoints), 'xb');
epts = linspace(out.a,out.b,100);
plot(epts, exp(2.*epts).*(1-epts).^(-alpha), '-m');
hold off