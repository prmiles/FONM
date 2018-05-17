function [sigma, test] = integer_order_linear_viscoelastic_stress(npar, ...
    time, stretch)

% extract model parameters
eta = npar.eta;
gamma = npar.gamma;

% define viscoelastic time constant
tau = eta/gamma;

n=length(stretch);
sigma = zeros(n,1); % Initial viscoelastic value
for ii = 2:n
    % calculate time step
    dta = time(ii) - time(ii-1);
    
    % define coefficients
    Tnc = 1 - dta/(2*tau);
    Tpc = 1 + dta/(2*tau);
    Tpcinv = Tpc.^(-1);
    
    % calculate viscoelastic stress
    sigma(ii) = Tpcinv.*(Tnc.*sigma(ii-1) ...
        + gamma*(stretch(ii) - stretch(ii-1)));
    
    test.Tnc(ii) = Tnc;
    test.Tpc(ii) = Tpc;
    test.Tpcinv(ii) = Tpcinv;
end