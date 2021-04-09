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
h = 0.001;           % 步长
velocity = v0;      % 速度求解
theta = theta0;         % theta求解
Y = y0;
X = x0;
i = 1;
mu = 0;
time = 0;
%mu = getmu(q0,X(i),Y(i));
alpha = alpha0;
q_ = q0;

% 开始迭代
while ( (Y(i)<yt) )
    current_mu = mu(i);
    % v
    K11 = getdv(velocity(i),theta(i),Y(i),X(i),alpha(i),q0,current_mu);
    K12 = getdv(velocity(i)+h*K11/2,theta(i),Y(i),X(i),alpha(i),q0,current_mu);
    K13 = getdv(velocity(i)+h*K12/2,theta(i),Y(i),X(i),alpha(i),q0,current_mu);
    K14 = getdv(velocity(i)+h*K13,theta(i),Y(i),X(i),alpha(i),q0,current_mu);
    velocity(i+1) = velocity(i) + h/6*(K11+2*K12+2*K13+K14);
    
    % theta
    K21 = getdtheta(velocity(i),theta(i),Y(i),X(i),alpha(i),q0,[getdy(velocity(i),theta(i)),K11],current_mu);
    K22 = getdtheta(velocity(i),theta(i)+h*K21/2,Y(i),X(i),alpha(i),q0,[getdy(velocity(i),theta(i)+h*K21/2),K11],current_mu);
    K23 = getdtheta(velocity(i),theta(i)+h*K22/2,Y(i),X(i),alpha(i),q0,[getdy(velocity(i),theta(i)+h*K22/2),K11],current_mu);
    K24 = getdtheta(velocity(i) ,theta(i)+h*K23,Y(i),X(i),alpha(i),q0,[getdy(velocity(i),theta(i)+h*K23),K11],current_mu);
    theta(i+1) = theta(i) + rad2deg(h/6*(K21+2*K22+2*K23+K24));
    
    % x & y
    X(i+1) = X(i) + h * getdx(velocity(i),theta(i));
    Y(i+1) = Y(i) + h * getdy(velocity(i),theta(i));
    
    % q
    q = acotd(cotd(q0) - current_mu*Isp*vt/yt/g/TWratio);
    q_(i+1) = q;
%     alpha(i+1) = getalpha(velocity(i+1),theta(i+1),Y(i+1),X(i+1),alpha(i),q0,K21,current_mu);
    alpha(i+1) = Stef(velocity(i),theta(i),Y(i),X(i),alpha(i),q0,K21,current_mu);
%     alpha(i+1)
    i = i+1;
    mu = [mu,mu(end)+h];
    time = [time,mu(end) * Isp / g / TWratio];      % 时间
end

%% 可视化
fprintf('导弹主级燃料相对质量因数:%g\n',mu(end));
figure(1)       % 导弹主级和目标运动轨迹
yt = ones(1,length(mu)) * yt;
xt = cotd(q_) .* yt;
plot(X,Y,'b',xt,yt,'r');
title('弹目运动轨迹示意图');
grid on
xlabel('x/m');
ylabel('y/m');
legend('导弹主级','目标','Location','best');

figure(2)               % 绘制V(t)曲线
plot(time,velocity);
title('主级火箭速度随时间变化曲线');
grid on
ylabel('V/单位：m/s');
xlabel('t/单位：s');

figure(3)               % 绘制theta(t)曲线
plot(time,theta);
title('主级火箭theta随时间变化曲线');
grid on
ylabel('theta/单位：degree');
xlabel('t/单位：s');

figure(4)               % 绘制alpha(t)曲线
plot(time,alpha);
title('主级火箭alpha随时间变化曲线');
grid on
ylabel('alpha/单位：degree');
xlabel('t/单位：s');

figure(5)               % 绘制q(t)曲线
plot(time,q_);
title('主级火箭q随时间变化曲线');
grid on
ylabel('q/单位：degree');
xlabel('t/单位：s');
