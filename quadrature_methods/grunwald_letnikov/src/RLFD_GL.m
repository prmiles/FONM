function [dalphadt] = RLFD_GL(f, alpha, N, t, h)

m = vpa(0:1:N-1,8);

% Calculate GL fractional derivative
coef = gamma(alpha+1)./((gamma(alpha-m+1)).*(gamma(m+1)));
tmp = (-1).^m.*coef.*f(t-m.*h);

dalphadt = 1/(h.^alpha)*sum(tmp);

end