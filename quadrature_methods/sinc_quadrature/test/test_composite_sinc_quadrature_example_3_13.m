% setup workspace
clear; close all; clc;

% define test problem
f = @(u, lambda) exp(-u).*sin(lambda.*u); %2*x*1i + 2;

T_correct = @(lambda) lambda./(lambda.^2 + 1);

alpha = 2;
beta = 1;

% ukh = @(k,h) exp(k.*h);
% phiprime = @(u) 1./(u);

ukh = @(k,h) log(exp(k*h) + sqrt(exp(2*k*h) + 1));
phiprime = @(u) 1./(tanh(u));

Ms = [4, 8, 16, 32];
lambdas = [1, 5 10];

for jj = 1:length(lambdas)
    lambda = lambdas(jj);
    fprintf('lambda = %i, Correct Answer = %4.4f\n', lambda, T_correct(lambda));
    
    for ii = 1:length(Ms)
        % define quadrature settings
        M = Ms(ii);
        N = 2*M;
        h = pi/sqrt(2*M);
        
        % evaluate quadrature
        T = 0;
        for kk = -M:1:N
            T = T + h*f(ukh(kk,h), lambda)./phiprime(ukh(kk,h));
        end
        
        % absolute error
        AE = abs(T_correct(lambda) - T);
        
        % display results
        fprintf('M = %2i, h = %6.4f, AE = %6.3e, T = %+6.4f\n', M, h, AE, T);
    end
end