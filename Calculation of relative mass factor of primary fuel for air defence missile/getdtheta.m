function dtheta = getdtheta(v,theta,y,x,alpha,q0,dargs,mu)
% 
dy = dargs(1);
dv = dargs(2);
vt = 420;
yt = 15e3;
Is = 2156;
g = 9.801;
TWratio = 2.2;

num = vt/yt*(Is/TWratio/g+1/v^2/sind(theta)*(v*dy-y*dv));
den = 1+(cotd(q0)-mu*Is*vt/TWratio/g/yt)*cotd(theta);
dtheta = num/den;
end

