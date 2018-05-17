function [sigma] = fractional_order_RL_FD_linear_viscoelastic_stress(npar, ...
    time, stretch)

% unpack model parameters
eta = npar.eta;
alpha = npar.alpha;

Ns = length(stretch);
sigma = zeros(Ns,1);
for ii = 2:Ns
    
    f = stretch(1:ii);
    N = length(f);
    
    % define grid
    gridpoints = time(1:ii);
    startpoints = gridpoints(1:end-1);
    endpoints = gridpoints(2:end);
    dt = (endpoints - startpoints)';
    
    % calculate g1
    jj = N-1;
    g1 = 0; % initialize term
    for kk = 1:jj
        term1 = (f(kk+1) + f(kk))/2;
        %         term1 = (f(gridpoints(kk+1)) + f(gridpoints(kk)))/2;
        %     term1 = f((gridpoints(kk+1) + gridpoints(kk))/2);
        term2 = (gridpoints(jj+1) - gridpoints(kk+1))^(1-alpha);
        term3 = (gridpoints(jj+1) - gridpoints(kk  ))^(1-alpha);
        g1 = g1 + term1*(term2 - term3);
    end
    
    % calculate g2
    jj = N-1;
    g2 = 0; % initialize term
    for kk = 2:jj
        term1 = (f(kk) + f(kk-1))/2;
        %     term1 = (f(gridpoints(kk)) + f(gridpoints(kk-1)))/2;
        %     term1 = f((gridpoints(kk) + gridpoints(kk-1))/2);
        term2 = (gridpoints(jj) - gridpoints(kk  ))^(1-alpha);
        term3 = (gridpoints(jj) - gridpoints(kk-1))^(1-alpha);
        g2 = g2 + term1*(term2 - term3);
    end
    
    sigma(ii) = -eta/(dt(ii-1)*gamma(2-alpha))*(g1 - g2);
end