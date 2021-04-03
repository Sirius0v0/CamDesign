function dtheta = getdtheta(v,theta,y,x,alpha,q0)
% 
mu = getmu(q0,x,y);
vt = 420;
yt = 15e3;
Is = 2156;
g = 9.801;
TWratio = 2.2;

num = vt/yt*(Is/TWratio/g+1/v^2/sind(theta)*(v*getdy(v,theta)-y*getdv(v,theta,y,x,alpha,q0)));
den = 1+(cotd(q0)-mu*Is*vt/TWratio/g/yt)*cotd(theta);
dtheta = num/den;
end

