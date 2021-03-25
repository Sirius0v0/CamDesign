function dy = getdy(v,theta)
% 
Is = 2156;
TWratio = 2.2;
g = 9.801;
dy = Is*v*sind(theta)/TWratio/g;
end

