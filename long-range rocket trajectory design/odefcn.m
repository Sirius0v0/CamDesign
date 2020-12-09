function dydt = odefcn(t, y, ppr, args)
% y = [theta, v, x, y]
%   此处显示详细说明
dydt = zeros(4,1);
dm = args(1);
g = args(2);
Aphi = args(3);
Pe = args(4);
m0 = args(5);
m = m0 - dm * t;
alpha = Aphi * (ppr(t) - y(1));
dydt(1) = (Pe*alpha/m + g*cos(y(1)))/y(2);
dydt(2) = Pe/m + g*sin(y(1));
dydt(3) = y(2) * cos(y(1));
dydt(4) = y(2) * sin(y(1));
end

