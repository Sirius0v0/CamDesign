function Mz = cal_Mz(alpha,delta_z,omega_z,H,V,am,bm,cm,mz_dz,mz_wz,L)
% mz = mz_alpha * alpha + mz_dz * delta_z + mz_wz * omega_z
% mz_alpha = am * alpha^3 + bm * alpha * abs(alpha) - cm * (7-8*Ma/3)*alpha

    if nargin == 5
        mz_dz = -0.206;                     % 舵偏引起的力矩系数
        mz_wz = -1.719;                     % 角速度引起的力矩系数
        am = 0.000215;
        bm = -0.0195;
        cm = 0.051;                         % 辅助系数
        L = 2;                              % 参考长度(m)
    end
    [qS,T] = cal_qS(H,V);
    Ma = V / (20.05*sqrt(T));
    mz_alpha = am * alpha^3 + bm * alpha * abs(alpha) - cm * (7-8*Ma/3)*alpha;
    mz = mz_alpha * alpha + mz_dz * delta_z + mz_wz * omega_z * L / V;
    Mz = mz * qS * L;
end