function gpts = base_gauss_points(precision)

extend_precision = 0;
if nargin > 3
    if ~isempty(precision) || precision > 1
        extend_precision = 1;
    end
end

% determines the Gauss points for a four point quadrature rule.
if extend_precision == 1
    gpts(1) = vpa((1/2) - sqrt(15+2*sqrt(30))/(2*sqrt(35)),precision);
    gpts(2) = vpa((1/2) - sqrt(15-2*sqrt(30))/(2*sqrt(35)),precision);
    gpts(3) = vpa((1/2) + sqrt(15-2*sqrt(30))/(2*sqrt(35)),precision);
    gpts(4) = vpa((1/2) + sqrt(15+2*sqrt(30))/(2*sqrt(35)),precision);
else
    gpts(1) = (1/2) - sqrt(15+2*sqrt(30))/(2*sqrt(35));
    gpts(2) = (1/2) - sqrt(15-2*sqrt(30))/(2*sqrt(35));
    gpts(3) = (1/2) + sqrt(15-2*sqrt(30))/(2*sqrt(35));
    gpts(4) = (1/2) + sqrt(15+2*sqrt(30))/(2*sqrt(35));
end