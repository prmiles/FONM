function Weights = gauss_weights(N,h,precision)

extend_precision = 0;
if nargin > 2
    if ~isempty(precision) || precision ~= 0
        extend_precision = 1;
    end
end

% determine the Gauss weights for a four point quadrature rule
weights = zeros(4,1);
if extend_precision == 1
    weights(1) = vpa(49*h/(12*(18 + sqrt(30))),precision);
    weights(2) = vpa(49*h/(12*(18 - sqrt(30))),precision);
    weights(3) = vpa(weights(2),precision);
    weights(4) = vpa(weights(1),precision);
else
    weights(1) = 49*h/(12*(18 + sqrt(30)));
    weights(2) = 49*h/(12*(18 - sqrt(30)));
    weights(3) = weights(2);
    weights(4) = weights(1);
end

% copy the weights to form a vector for all N intervals

Weights = weights;
for gct = 1:N-1
    Weights = [Weights; weights];
end;