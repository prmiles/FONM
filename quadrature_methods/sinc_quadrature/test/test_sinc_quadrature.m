% setup workspace
clear; close all; clc;

% add path to sinc quadrature source code
pathtosrc = '../src/';
addpath(pathtosrc);

% define test problem
f = @(x)(1-x)^(-.9)*exp(2*x); %1./x.^(0.7); %2*x*1i + 2;
correct_answer = 10/3;
t0 = 0;
t = 1;

alpha = 3;
beta = 1;

M = 90;
N = floor(abs(alpha/beta*M + 1));
d = pi/2;
h = sqrt(pi*d/(alpha*M));%pi*sqrt(beta./(alpha*M));

% nodes and weights for (0,1)
% ukh = @(k,h) exp(k.*h)./(exp(k.*h) + 1);
% phiprime = @(u) 1./(u.*(1-u));

% nodes and weights for (a,b)
ukh = @(k,h,a,b)(b*exp(k.*h)+a)./(exp(k.*h) + 1);
phiprime = @(u,a,b) (b-a)./((u-a)*(b-u));

% nodes and weights for (0,inf)
% ukh = @(k,h) log(exp(k*h) + sqrt(exp(2*k*h) + 1));
% phiprime = @(u) 1./(tanh(u));

T = 0;
nodes = [];
for kk = -M:1:N
    T = T + h.*f(ukh(kk,h,t0,t))./phiprime(ukh(kk,h,t0,t),t0,t);
    nodes = [nodes, ukh(kk,h,t0,t)];
end

figure()
plot(-M:1:N,nodes)

fprintf('T = %4.4f, Correct Answer = %4.4f\n', T, correct_answer);
fprintf('\t M = %i, N = %i, h = %4.2f\n', M, N, h)

rmpath(pathtosrc);