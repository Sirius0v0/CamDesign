function mu = getmu(q0,x,y)
% mu = getmu(q0,x,y)
TWratio = 2.2;
g = 9.801; 
yt = 15e3;
Is = 2156;
vt = 420;

mu = TWratio * g * yt * (1/tand(q0)-1/tand(cal_deg(0,0,x,y)))/Is/vt;
end

