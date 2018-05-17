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

inputsettings.a = t0;
inputsettings.b = t;
inputsettings.alpha = 1;
inputsettings.beta = 1;
inputsettings.d = pi/2;

M = 1;
[T,settings] = sinc_quad(f,M,inputsettings);

fprintf('T = %4.4f, Correct Answer = %4.4f\n', T, correct_answer);
fprintf('\t M = %i, N = %i, h = %4.2f\n', M, settings.N, settings.h)

rmpath(pathtosrc);