function d = cal_deg(x1, y1, x2, y2)
% 计算A(x1,y1)B(x2,y2)向量与x轴正方向的夹角 即θ<(x2-x1,y2-y1),(0,1)>
% 单位：度
    Y = y2-y1;
    X = x2-x1;
    d = atan2d( Y,X );
    if ( Y < 0 )
        d = d + 360;
    end
end