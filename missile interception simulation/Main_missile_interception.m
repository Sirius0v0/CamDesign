clear;
close all
clc;

%% 导弹的弹道参数
% 弹体相关
m0 = 204;                           % 弹体初始质量(kg)
Jz = 247.43;                        % 弹体绕z转动惯量(kg·m^2)
S = 0.0409;                         % 参考面积(m^2)
L = 2;                              % 参考长度(m)
d_ref = 0.2286;                     % 参考面积圆的直径(m)
P = 1e4;                            % 发动机推力(N)
dmdt = 3.6;                         % 弹体质量秒消耗量(kg/s)

% 阻力相关 
% Cx = C_x0 + C_x_alpha * alpha
C_x0 = 0.05;                        % 零升阻力系数    
C_x_alpha = 0.2 * pi/180;           % 攻角引起的阻力系数(deg)

% 升力相关 
% Cy = C_y_alpha * alpha + C_y_dz * delta_z
% C_y_alpha = an * alpha^3 + bn * alpha * abs(alpha) + cn * (2-Ma/3)*alpha
% 攻角单位：度
C_y_dz = -0.034;                    % 舵偏引起的升力系数(deg)
an = -0.000103;
bn = 0.00945;
cn = 0.01696;                       % 辅助系数

% 俯仰力矩相关
% mz = mz_alpha * alpha + mz_dz * delta_z + mz_wz * omega_z
% mz_alpha = am * alpha^3 + bm * alpha * abs(alpha) - cm * (7-8*Ma/3)*alpha
mz_dz = -0.206;                     % 舵偏引起的力矩系数
mz_wz = -1.719;                     % 角速度引起的力矩系数
am = 0.000215;
bm = -0.0195;
cm = 0.051;                         % 辅助系数

% 导弹约束相关
ALPHA_MAX = 20;                     % 最大迎角(deg)
ALPHA_MIN = -5;                     % 最小迎角(deg)
DELTA_Z_MAX = 30;                   % 最大舵偏角(deg)
DELTA_Z_MIN = -30;                  % 最小舵偏角(deg)

%% 仿真初值
x0 = 0;
y0 = 3048;
z0 = 0;                             % 导弹初始坐标（x,y,z）/单位：m

v0 = 984;                           % 发射点速度（m/s）
vartheta0 = 0;                      % 发射点俯仰角（deg）
omega_z0 = 0;                       % 发射点俯仰角速度（deg/s）
theta0 = 0;                         % 发射点弹道倾角(deg)
psi_v = 0;                          % 发射点弹道偏角(deg)
v_target0 = 325;                    % 目标初始速度(m/s)
theta_target = 180;                 % 目标初始弹道倾角(deg)
x_target0 = 13610;
y_target0 = 3548;                   % 目标初始坐标(x,y)/单位:m
q0 = cal_deg(x0,y0,x_target0,y_target0);    % 初始视线角(deg)
K = 3.5;                            % 比例导引律.比例系数
g = 9.8;                            % 重力加速度
r0 = ( (y_target0 - y0)^2 + (x_target0 - x0)^2 )^.5;    % 弹目距离
%% 弹道偏差

%% 求解
% 初始值
y_initial = [v0, theta0, omega_z0, vartheta0, x0, y0, m0, x_target0,y_target0, q0,0,r0]';% 第(end-1)是导引律下的弹道倾角，初始值为0
t_step = 0.0005;                     % 步长
tspan = [0, 10];                     % 积分范围
t = tspan(1):t_step:tspan(2);       % 离散化数据
% 可调参数
Kp = 0.8;                        % 舵偏比例系数
Kd = 3.027;                    % 舵偏微分系数
% Kp = 88.9;                        % 舵偏比例系数
% Kd = 107.027;                    % 舵偏微分系数
RANGE = 1;                      % 打靶误差   

y = ones(1,length(t));
y = y_initial * y;            % 预分配内存 提高运行速度
d_theta_xing_dian = 0;
d_theta_dian = 0;             % 弹道倾角速度的初值（不定义在求解参数中，节省内存）
stop = length(t);             % 记录拦截节点  
for i = 2:length(t)
% y = [1弹体速度，2弹道倾角，3俯仰角速度，4俯仰角，5导弹横坐标，6导弹纵坐标，7质量，8目标横坐标,9目标纵坐标，10视线角微分项,11导引弹道倾角，12弹目距离]

% 参数预备
alpha = y(4,i-1) - y(2,i-1);                % 攻角
% 修正至允许攻角范围
if (alpha > ALPHA_MAX)
    alpha = ALPHA_MAX;
elseif (alpha < ALPHA_MIN)
    alpha = ALPHA_MIN;
end
delta_theta = y(2,i-1) - y(11,i-1);         % 弹道倾角误差
delta_z = Kp * delta_theta + Kd * (d_theta_dian - d_theta_xing_dian);
% 修正至最大偏转角度
if (delta_z > DELTA_Z_MAX)
    delta_z = DELTA_Z_MAX;
elseif (delta_z < DELTA_Z_MIN)
    delta_z = DELTA_Z_MIN;
end
X = cal_X(alpha,y(6,i-1),y(1,i-1));
Y = cal_Y(alpha,delta_z,y(6,i-1),y(1,i-1));
Mz = cal_Mz(alpha,delta_z,y(3,i-1),y(6,i-1),y(1,i-1));

y(1,i) = y(1,i-1) + ( ( P * cosd(alpha) - X )/y(7,i-1) - g * sind(y(2,i-1)) ) * t_step;
y(2,i) = y(2,i-1) + ( ( P * sind(alpha) + Y )/y(7,i-1)/y(1,i-1) - g * cosd(y(2,i-1))/y(1,i-1) ) * t_step;
y(3,i) = y(3,i-1) + rad2deg( ( Mz / Jz ) * t_step );
y(4,i) = y(4,i-1) + ( y(3,i-1) ) * t_step;
y(5,i) = y(5,i-1) + ( y(1,i-1) * cosd(y(2,i-1)) ) * t_step;
y(6,i) = y(6,i-1) + ( y(1,i-1) * sind(y(2,i-1)) ) * t_step;
y(7,i) = y(7,i-1) + ( -dmdt ) * t_step;
y(8,i) = y(8,i-1) + ( -v_target0 ) * t_step;
y(9,i) = y(9,i-1) + 0;
y(10,i) = (cal_deg(y(5,i),y(6,i),y(8,i),y(9,i)) - cal_deg(y(5,i-1),y(6,i-1),y(8,i-1),y(9,i-1)) )/t_step;
y(11,i) = y(11,i-1) + K * y(10,i) * t_step;
y(12,i) = ( (y(8,i) - y(5,i))^2 + (y(9,i) - y(6,i))^2 )^.5;

d_theta_dian = ( y(2,i) - y(2,i-1) )/t_step;
d_theta_xing_dian = ( y(11,i) - y(11,i-1) )/t_step;

if (stop == length(t))      % 当尚未记录停止位置时进入
    if ( y(12,i) < RANGE )
        stop = i;           % 记录停止位置
    end
end

end

% 信息输出
if (min(y(12,:)) < RANGE)
    fprintf('已成功拦截目标！拦截位置(%.3f , %.3f)m\n',y(8,stop),y(9,stop));
end
fprintf('距离目标最近%.4fm\n',min(y(12,1:stop)))
%% 可视化
figure('Name','导弹拦截飞行轨道')
hold on
plot(y(5,1:stop),y(6,1:stop))
plot(y(8,1:stop),y(9,1:stop))
hold off
xlabel('水平位置 x');
ylabel('竖直位置 y');
title('导弹拦截飞行轨道');

figure('Name','速度随时间变化图')
plot(t(1:stop),y(1,1:stop))
xlabel('时间 t');
ylabel('导弹速度');
title('速度随时间变化图');

figure('Name','导弹与目标间距随时间变化图')
plot(t(1:stop),y(12,1:stop));
xlabel('时间 t');
ylabel('导弹与目标间距');
title('导弹与目标间距随时间变化图');

figure('Name','弹道倾角随时间变化图')
plot(t(1:stop),y(2,1:stop));
xlabel('时间 t');
ylabel('弹道倾角');
title('弹道倾角随时间变化图');

figure('Name','攻角随时间变化图')
plot(t(1:stop-0.5/t_step),y(4,1:stop-0.5/t_step)-y(2,1:stop-0.5/t_step));
xlabel('时间 t');
ylabel('攻角');
title('攻角随时间变化图');



%% GIF显示拦截过程
isGenerate = 0;             % 绘制GIF动画开关，1为开，0为关
if isGenerate
    filename = strcat(datestr(now,30),'.gif');
    close all
    hold on;
    f_num = 1;
    for j = 1:150:stop
        plot(y(5,j),y(6,j),'r.','markersize',12);
        plot(y(8,j),y(9,j),'b.','markersize',12);
        title(strcat('Block animation    time:',num2str(j*t_step),'s'));
        xlabel('Horizontal position/m')
        ylabel('Vertical position/m')
    
        F = getframe(gcf);
        I = frame2im(F);
    
        [I,map] = rgb2ind(I,256);
        if f_num == 1
            imwrite(I,map,filename,'gif','Loopcount',inf,'DelayTime',0.05);
        else
            imwrite(I,map,filename,'gif','WriteMode','append','DelayTime',0.05);
        end
        f_num = f_num + 1;
    end 
end