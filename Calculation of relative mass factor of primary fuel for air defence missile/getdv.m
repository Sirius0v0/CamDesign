function dv = getdv(v,theta,y,x,alpha,q0)
% dv = getdv(v,theta,y,mu,alpha)
mu = getmu(q0,x,y);
Is = 2156;  
TWratio = 2.2;
wingloading = 5880; 
[~,a,rho] = getatmos(y);
Ma = v/a;
dv = Is/(1-mu)-(rho*v^2*Cx(Ma,alpha)*Is)/(2*TWratio*wingloading*(1-mu))-Is/TWratio*sind(theta);

end

