function [alpha,e1] = Stef(v,theta,y,x,alpha,q0,dtheta,mu,e)
%Steffensen加速迭代法
%   fx: f=f(x)中的函数部分字符串，即'f(x)';
%   x0: 迭代初始值；
%   e:  控制误差限，默认为1e-6;
    if nargin == 8
        e = 1e-6;
    end
    
    e1 = 100;
    
    while(e1 > e)
        s = getalpha(v,theta,y,x,alpha,q0,dtheta,mu);
        t = getalpha(v,theta,y,x,s,q0,dtheta,mu);
        alpha_1 = alpha - (s-alpha)^2./(t-2*s+alpha);
        e1 = abs(alpha_1 - alpha);
        alpha = alpha_1;
    end
end