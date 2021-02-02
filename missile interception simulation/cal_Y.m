function Y = cal_Y(alpha,delta_z,H,V,an,bn,cn,C_y_dz)
% Cy = C_y_alpha * alpha + C_y_dz * delta_z
% C_y_alpha = an * alpha^3 + bn * alpha * abs(alpha) + cn * (2-Ma/3)*alpha
    if nargin == 4
        C_y_dz = -0.034;                    % 舵偏引起的升力系数(deg)
        an = -0.000103;
        bn = 0.00945;
        cn = 0.01696;                       % 辅助系数
    end
    [qS,T] = cal_qS(H,V);
    Ma = V / (20.05*sqrt(T));
    C_y_alpha = an * alpha^3 + bn * alpha * abs(alpha) + cn * (2-Ma/3)*alpha;
    Cy = C_y_alpha * alpha + C_y_dz * delta_z;
    Y = Cy * qS;
end