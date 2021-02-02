function [qs,T] = cal_qS(H,V,S)
% 计算 X = Cx * q * S中的qS
%   @ H :海拔高度
%   @ V :导弹速度
%   @ S :参考面积
if nargin == 2
    S = 0.0409;
end

rho_0 = 1.2495;
T_0 = 288.15;
T = T_0 - 0.0065 * H;
rho = rho_0 * (T / T_0)^4.25588;
qs = rho * V^2 /2 * S;
end