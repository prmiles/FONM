function [T,settings] = sinc_quad(f,M,inputsettings)
% function [T,settings] = sinc_quad(f,M,inputsettings)
%
% Description: This function is intended to perform sinc quadrature,
% allowing for a variety of input parameters.  For details regarding the
% sinc quadrature method, the user is referred to 
% - Lund, John, and Kenneth L. Bowers. Sinc methods for quadrature and 
%   differential equations. Siam, 1992.
%
% Basic settings
% - a: lower integration limit (default = 0)
% - b: upper integration limit (default = 1)
% - alpha: scale factor in integration method (default = 1)
% - beta: shape factor in integration method (default = 1)
% - d: ??? factor in integration method (default = pi/2)

% unpack input arguments
if nargin < 3 || isempty(inputsettings)
    inputsettings.defined = 0;
end

inputfields = fields(inputsettings);

% default settings
settings.a = 0;
settings.b = 1;
settings.alpha = 1;
settings.beta = 1;
settings.d = pi/2;

validfields = fields(settings);

% determine valid fields specified by user
checkfields = intersect(inputfields, validfields);
nvf = length(checkfields);

for ii = 1:nvf
    if isempty(inputsettings.(checkfields{ii}))
    else
        settings.(checkfields{ii}) = inputsettings.(checkfields{ii});
    end
end

a = settings.a;
b = settings.b;
alpha = settings.alpha;
beta = settings.beta;
d = settings.d;

% calculate dependent settings
N = floor(abs(alpha/beta*M + 1));
h = sqrt(pi*d/(alpha*M));

% nodes and weights for (a,b)
ukh = @(k,h)(b*exp(k.*h)+a)./(exp(k.*h) + 1);
phiprime = @(u) (b-a)./((u-a)*(b-u));

T = 0;
points = -M:1:N;
nodes = zeros(length(points),1);
weights = zeros(length(points),1);
count = 0;
for kk = points
    node = ukh(kk,h);
    weight = h./phiprime(node);
    T = T + f(node)*weight;
    count = count + 1;
    nodes(count) = node;
    weights(count) = weight;
end

% add variables to settings for analysis
settings.N = N;
settings.h = h;
settings.nodes = nodes;
settings.weights = weights;
end