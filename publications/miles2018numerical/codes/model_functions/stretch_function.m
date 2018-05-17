function L = stretch_function(t)

ts = 5/0.67;%vpa(8,2);
% tf = 2*ts;%vpa(16,2);
u1 = 0.67;
u2 = -0.67;

% lambda = @(t) 1 + (t<ts).*t*u1 + (t>=ts).*(((t-ts)*u2) + ts*u1);
if t < ts
    L = 1 + t*u1;
else
    L = 1 + (t-ts)*u2 + ts*u1;
end