function dydt = odefun3(t,y)
dydt = zeros(2,1);
dydt(1) = -2*y(1);
dydt(2) = 3*y(1)+2*y(2);
end