function Gpts = interval_gauss_points(gpts, N, h, low_lim)
% determines the Gauss points for all N intervals.
Gpts = zeros(4*N,length(h));
for gct = 1:N
    for ell = 1:4
        Gpts((gct-1)*4 + ell,:) = (gct-1)*h(:) + gpts(ell)*h(:) + low_lim;
    end;
end;