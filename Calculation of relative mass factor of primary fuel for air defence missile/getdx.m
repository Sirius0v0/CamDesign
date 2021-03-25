function dx = getdx(v,theta)
% 
Is = 2156;
TWratio = 2.2;
g = 9.801;
dx = Is*v*cosd(theta)/TWratio/g;
end