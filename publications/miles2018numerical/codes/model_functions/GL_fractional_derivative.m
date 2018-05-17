function [dalphadt] = GL_fractional_derivative(alpha, f, t, coef, h, m, ii)
% Calculate GL fractional derivative
d = 1:1:floor(t.*(1/h))+1;
tmp = coef(d).*f(t-m(d).*h);
dalphadt = 1/(h.^alpha)*sum(tmp);

end