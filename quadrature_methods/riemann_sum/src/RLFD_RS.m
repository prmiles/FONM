function [dalphadt, int1, int2] = RLFD_RS(f, N, alpha, t0, t)

% define grid
gridpoints = linspace(t0,t,N);
dt = gridpoints(2)-gridpoints(1); %all the same

% calculate g1
jj = N-1;
int1 = 0; % initialize term
for kk = 1:jj
    %     term1 = (f(gridpoints(kk+1)) + f(gridpoints(kk)))/2;
    term1 = f((gridpoints(kk+1) + gridpoints(kk))/2);
    term2 = (gridpoints(jj+1) - gridpoints(kk+1))^(1-alpha);
    term3 = (gridpoints(jj+1) - gridpoints(kk  ))^(1-alpha);
    int1 = int1 + term1*(term2 - term3);
end

% calculate g2
jj = N-1;
int2 = 0; % initialize term
for kk = 2:jj
    %     term1 = (f(gridpoints(kk)) + f(gridpoints(kk-1)))/2;
    term1 = f((gridpoints(kk) + gridpoints(kk-1))/2);
    term2 = (gridpoints(jj) - gridpoints(kk  ))^(1-alpha);
    term3 = (gridpoints(jj) - gridpoints(kk-1))^(1-alpha);
    int2 = int2 + term1*(term2 - term3);
end

dalphadt = -1/(dt*gamma(2-alpha))*(int1 - int2);