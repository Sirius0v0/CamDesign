function alpha_ = getalpha(v,theta,y,mu,alpha,q0)
% 
vt = 420;
yt = 15e3;
Is = 2156;
g = 9.801;
TWratio = 2.2;
wingloading = 5880; 
[~,a,rho] = getatmos(y);
Ma = v/a;

num = v*getdtheta(v,theta,y,mu,alpha,q0)+Is*cosd(theta)/TWratio;
den = (rho*v^2*Cya(Ma,alpha)*Is)/(2*TWratio*wingloading*(1-mu))+Is/(1-mu);
alpha_ = num/den;
% alpha_ = rad2deg(alpha_);
end

