function dydt = odefcn(t, y, ppr, args)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
dydt = zeros(4,1);
dm = args(1);
g = args(2);
Aphi = args(3);
Pe = args(4);
m0 = args(5);
m = m0 - dm * t;
alpha = Aphi * (ppr(t) - y(2));
dydt(1) = Pe/m + g*sin(y(2));
dydt(2) = (Pe*alpha/m + g*cos(y(2)))/y(1);
dydt(3) = y(1) * cos(y(2));
dydt(4) = y(1) * sin(y(2));
end

