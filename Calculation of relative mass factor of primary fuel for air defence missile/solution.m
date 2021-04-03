%% 清空数据
clear
close all
clc

%% 导入基本参数
% 发动机参数
Isp = 2156;             % 比冲N·s/kg
g = 9.801;              
TWratio = 2.2;          % 推重比
wingloading = 5880;     % 翼载N/m2

% 目标
vt = 420;               % 目标速度m/s
yt = 15e3;              % 目标高度m
Dmt0 = 34200;           % 初始弹目距离m

% 导弹分离初始值
v0 = 500;               % 分离速度
t0 = 3;                 % 时间
x0 = 674;               % x方向位置
y0 = 329;               % y方向位置
alpha0 = 1.5;           % 初始攻角(deg)
theta0 = 26;            % 初始弹道倾角(deg)

% 相关数值计算
xt0 = x0 + (Dmt0^2 - (yt-y0)^2)^0.5;     % 目标初始x位置
q0 = cal_deg(x0,y0,xt0,yt);         % 初始航向角

%%
args = [Isp,TWratio,wingloading,vt,yt,g,q0];
%% 龙格库塔求解
h = 0.0001;           % 步长
velocity = v0;      % 速度求解
theta = theta0;         % theta求解
Y = y0;
X = x0;
i = 1;
mu = 0;
%mu = getmu(q0,X(i),Y(i));
alpha = alpha0;
q_ = q0;

% 开始迭代
while ( (Y(i)<yt) )

    % K1 = f(x,y)
    K11 = getdv(velocity(i),theta(i),Y(i),X(i),alpha(i),q0);
    K21 = getdtheta(velocity(i),theta(i),Y(i),X(i),alpha(i),q0);
    K31 = getdy(velocity(i),theta(i));
    K41 = getdx(velocity(i),theta(i));
    
    % K2 = f(x+h/2,y+h*K1/2)
    K12 = getdv(velocity(i)+h*K11/2,theta(i)+h*K21/2,Y(i)+h*K31/2,X(i)+h*K41/2,alpha(i),q0);
    K22 = getdtheta(velocity(i)+h*K11/2,theta(i)+h*K21/2,Y(i)+h*K31/2,X(i)+h*K41/2,alpha(i),q0);
    K32 = getdy(velocity(i)+h*K11/2,theta(i)+h*K21/2);
    K42 = getdx(velocity(i)+h*K11/2,theta(i)+h*K21/2);
    
    % K3 = f(x+h/2,y+h*K2/2)
    K13 = getdv(velocity(i)+h*K12/2,theta(i)+h*K22/2,Y(i)+h*K32/2,X(i)+h*K42/2,alpha(i),q0);
    K23 = getdtheta(velocity(i)+h*K12/2,theta(i)+h*K22/2,Y(i)+h*K32/2,X(i)+h*K42/2,alpha(i),q0);
    K33 = getdy(velocity(i)+h*K12/2,theta(i)+h*K22/2);
    K43 = getdx(velocity(i)+h*K12/2,theta(i)+h*K22/2);
    
    % K4 = f(x+h,y+h*K3)
    K14 = getdv(velocity(i)+h*K13,theta(i)+h*K23,Y(i)+h*K33,X(i)+h*K43,alpha(i),q0);
    K24 = getdtheta(velocity(i)+h*K13,theta(i)+h*K23,Y(i)+h*K33,X(i)+h*K43,alpha(i),q0);
    K34 = getdy(velocity(i)+h*K13,theta(i)+h*K23);
    K44 = getdx(velocity(i)+h*K13,theta(i)+h*K23);
    
    % y_n+1 = y_n + h/6*(K1+2*K2+2*K3+K4)
    velocity(i+1) = velocity(i) + h/6*(K11+2*K12+2*K13+K14);
    theta(i+1) = theta(i) + h/6*(K21+2*K22+2*K23+K24);
    X(i+1) = X(i) + h/6*(K31+2*K32+2*K33+K34);
    Y(i+1) = Y(i) + h/6*(K41+2*K42+2*K43+K44);
    q = cal_deg(0,4,X(i+1),Y(i+1));
    q_(i+1) = q;
    alpha(i+1) = getalpha(velocity(i+1),theta(i+1),Y(i+1),X(i+1),alpha(i),q0);
    i = i+1;
end
mu = mu(1):h:(mu(1)+h*(i-1));
time = mu * Isp / g / TWratio;  % 时间

