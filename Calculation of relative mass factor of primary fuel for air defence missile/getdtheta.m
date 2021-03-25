function dtheta = getdtheta(v,theta,y,mu,alpha,q0)
% 

vt = 420;
yt = 15e3;
Is = 2156;
g = 9.801;
TWratio = 2.2;

num = vt/yt*(Is/TWratio/g+1/v^2/sind(theta)*(v*getdy(v,theta)-y*getdv(v,theta,y,mu,alpha)));
den = 1+(1/tand(q0)-mu*Is*vt/TWratio/g/yt)/tand(theta);
dtheta = num/den;
end

