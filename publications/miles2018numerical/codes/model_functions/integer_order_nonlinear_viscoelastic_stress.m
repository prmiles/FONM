function [q] = integer_order_nonlinear_viscoelastic_stress(npar, time, stretch, ...
    hyperelastic_stress, derivative_hyperelastic_stress)
 
% -------------------------------------------------------------------------
% Viscoelastic Stress
% Parameters
eta = npar.eta;   % [kPa*s]
gamma = npar.gamma; % [kPa];
beta = npar.beta;  % [-];

n=length(stretch);
Q = zeros(n,1); % Initial viscoelastic value

p = 1:1:n;
ds = setdiff(p,0+1); % removes starting indices
for kk = 1:length(ds);
    ii = ds(kk);
    dta = time(ii) - time(ii-1);
    Tnc = 1 - gamma*dta/(2*eta);
    Tpc = 1 + gamma*dta/(2*eta);
    Tpcinv = Tpc.^(-1);
    
    Q(ii) = Tpcinv.*(Tnc.*Q(ii-1) + beta*(hyperelastic_stress(ii) - hyperelastic_stress(ii-1)));
end

% Internal state variable
Gamma = 1/gamma*(beta*hyperelastic_stress-Q);

% Viscoelastic stress
q = beta*(hyperelastic_stress - (derivative_hyperelastic_stress(:)).*Gamma(:)); 

% -------------------------------------------------------------------------
% Viscoelastic stress
q = q(:); % (kPa)
end
