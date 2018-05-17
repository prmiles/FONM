function [int, settings] = composite_guassian_quadrature(ker, inputsettings)

% unpack input arguments
if nargin < 2 || isempty(inputsettings)
    inputsettings.defined = 0;
end

inputfields = fields(inputsettings);

% default settings
settings.precision = 0;
settings.a = 0;
settings.b = 1;
settings.n = 1;

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
n = settings.n;
precision = settings.precision;

dt = (b-a)/(n-1);

% create gauss points & weights
if precision > 1
    gpoints = gauss_points(n-1, dt, a, precision);
    gweights = gauss_weights(n-1, dt, precision);
else
    gpoints = gauss_points(n-1, dt, a);
    gweights = gauss_weights(n-1, dt);
end

% % evaluate integral using gaussian quadrature
int = sum(gweights.*ker(gpoints));

settings.gpoints = gpoints;
settings.gweights = gweights;
settings.kernel = ker;