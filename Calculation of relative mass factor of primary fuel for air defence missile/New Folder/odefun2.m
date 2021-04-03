function dydt = odefun2(t,y)
dydt = zeros(2,1);
t = 2*y(2);
dydt(1) = -2*y(1);
dydt(2) = 3*y(1)+t;
end