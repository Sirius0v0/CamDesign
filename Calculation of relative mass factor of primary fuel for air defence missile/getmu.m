function mu = getmu(q0,q)
% mu = getmu(q0,q)
TWratio = 2.2;
g = 9.801; 
yt = 15e3;
Is = 2156;
vt = 420;

mu = TWratio * g * yt * (1/tand(q0)-1/tand(q))/Is/vt;
end

