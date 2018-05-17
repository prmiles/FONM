function [g1] = riemann_sum_RL_FD(f, gridpoints, alpha)
N = length(gridpoints);
% calculate g1
jj = N-1;
g1 = 0; % initialize term
% feval = f(gridpoints(2:jj+1) + gridpoints(1:jj));
for kk = 1:jj
    %     term1 = (f(gridpoints(kk+1)) + f(gridpoints(kk)))/2;
    term1 = f((gridpoints(kk+1) + gridpoints(kk))/2);
%     term1 = feval(kk);
    term2 = (gridpoints(jj+1) - gridpoints(kk+1))^(1-alpha);
    term3 = (gridpoints(jj+1) - gridpoints(kk  ))^(1-alpha);
    g1 = g1 + term1*(term2 - term3);
end
g1 = -1/(1-alpha)*g1;