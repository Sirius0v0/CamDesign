function [T,a,rho] = getatmos(H)
% 获取当地温度，声速，密度
% 温度
T = (288.15-0.0065*H) .* (H <= 11e3) + 216.65 .* (H>11e3 & H <= 20e3) + (216.65+0.001*(H-20000)) .* (H > 20e3);
% 密度
Ta = 288.15;
rhoa = 1.225;
rhotemp = (rhoa*(216.65/Ta)^4.25588);
rho = (rhoa * (T./Ta).^4.25588) .* (H <= 11e3) + ...
    (rhotemp * exp(-(H-11000)/6341.62)) .* (H>11e3 & H <= 20e3) + ...
    (rhotemp * (T./216.65).^-35.1632) .* (H > 20e3);

% 声速
a = 20.05*T.^0.5;

end