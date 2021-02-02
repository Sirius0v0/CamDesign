function Cx = cal_Cx(alpha,C_x0,C_x_alpha)
% Cx = C_x0 + C_x_alpha * alpha
    if nargin == 1
        C_x0 = 0.05;                        % 零升阻力系数    
        C_x_alpha = 0.2 * pi/180;           % 攻角引起的阻力系数(deg)
    end
    Cx = C_x0 + C_x_alpha * alpha;
end

