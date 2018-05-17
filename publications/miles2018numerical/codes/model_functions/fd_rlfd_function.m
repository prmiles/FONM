function [dalphadt] = fd_rlfd_function(f, gridpoints, alpha)

% define grid
N = length(gridpoints);
startpoints = gridpoints(1:end-1);
endpoints = gridpoints(2:end);
dt = (endpoints - startpoints)';

% calculate g1
jj = N-1; 
g1 = 0; % initialize term
for kk = 1:jj
%     term1 = (f(kk+1) + f(kk))/2;
    term1 = f((gridpoints(kk+1) + gridpoints(kk))/2);
    term2 = (gridpoints(jj+1) - gridpoints(kk+1))^(1-alpha);
    term3 = (gridpoints(jj+1) - gridpoints(kk  ))^(1-alpha);
    g1 = g1 + term1*(term2 - term3);
end

% calculate g2
jj = N-1; 
g2 = 0; % initialize term
for kk = 2:jj
%     term1 = (f(kk) + f(kk-1))/2;
    term1 = f((gridpoints(kk) + gridpoints(kk-1))/2);
    term2 = (gridpoints(jj) - gridpoints(kk  ))^(1-alpha);
    term3 = (gridpoints(jj) - gridpoints(kk-1))^(1-alpha);
    g2 = g2 + term1*(term2 - term3);
end

dalphadt = -1/(mean(dt)*gamma(2-alpha))*(g1 - g2);