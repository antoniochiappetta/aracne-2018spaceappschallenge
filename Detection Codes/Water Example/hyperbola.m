function K = hyperbola(x,y,V1,V2,CDT)
% Hyperbola equation for implicit plot

% Focus
x1  = V1(1);
y1  = V1(2);
x2  = V2(1);
y2  = V2(2);

% Equation
K = sqrt((x-x1).^2+(y-y1).^2)-sqrt((x-x2).^2+(y-y2).^2)-CDT;
