clear;
close all;
clc
%% 原系统根轨迹及单位阶跃响应曲线
sys_raw_open = tf([2 0.1],[1 0.1 4 0]);     % 原系统开环传递函数
sys_raw_close = tf([2 0.1],[1 0.1 6 0.1]);  % 原系统闭环传递函数
figure;step(sys_raw_close);   % 阶跃响应
title('原系统单位阶跃响应曲线')
figure;rlocus(sys_raw_open); % 根轨迹
title('原系统根轨迹曲线')

%% 确定校正网络零极点（平分线法）
Y = [2*3^0.5 0 2*3^0.5];
X = [-2 0 -5];
S = [-2 2*3^.5];
figure;
[pingfen_x, pingfen_y] = draw_pingfen(X,Y);
hold on
rot(pingfen_x, pingfen_y, S, 18.33875);
rot(pingfen_x, pingfen_y, S, -18.33875);
% 坐标轴
plot(linspace(-7,1,1000), zeros(1,1000), 'k:');
plot(zeros(1,1000), linspace(-1,5,1000), 'k:')
hold off
z = -2.7157; p = -5.8939;
s = -2 + 2*3^.5*1i;   
K_c = sqrt( abs(s-p)*abs(s-p) * abs(s^3+0.1*s^2+4*s)/...
    (abs(2*s+0.1)*abs(s-z)*abs(s-z)) );

%% 校正后系统根轨迹及单位阶跃响应曲线
numerator = K_c^2 * conv([1 -z], conv([2 0.1],[1 -z]));
denominator = conv([1 0.1 4 0], conv([1 -p],[1 -p]));
sys_cor_open = tf(numerator, denominator);
sys_cor_close = tf(numerator,[0,0,numerator]+denominator);  % 原系统闭环传递函数
figure;step(sys_cor_close);   % 阶跃响应
title('原系统单位阶跃响应曲线')
figure;rlocus(sys_cor_open); % 根轨迹
title('原系统根轨迹曲线')

%% 附加功能函数部分
function [line_x, line_y] = draw_pingfen(X,Y)
% X为三点横坐标，Y为三点纵坐标
% 利用内心坐标公式画角平分线 并返回角平分线坐标
% 注意 被平分角应输入为(x1,y1)的位置
A = [X(1), Y(1)];
B = [X(2), Y(2)];
C = [X(3), Y(3)];
a = sqrt(sum((B-C).^2));
b = sqrt(sum((A-C).^2));
c = sqrt(sum((B-A).^2));
cent = [(a*A(1)+b*B(1)+c*C(1))/(a+b+c), (a*A(2)+b*B(2)+c*C(2))/(a+b+c)];
t = 0:0.01:1;
tt = 0:0.01:6;
line_x = ((cent(1)-A(1)).*tt+A(1))';
line_y = ((cent(2)-A(2)).*tt+A(2))';
hold on
plot((B(1)-A(1)).*t+A(1), (B(2)-A(2)).*t+A(2), 'k-');
plot((C(1)-A(1)).*t+A(1), (C(2)-A(2)).*t+A(2), 'k-');
plot(line_x, line_y, 'b-');
hold off
end

function [line_x, line_y] = rot(x,y,P,theta)
% 给定线段坐标(x,y) 使得绕P点旋转theta角度画出图像并返回旋转线段坐标值
line_x = (x-P(1)) * cosd(theta) - (y-P(2)) * sind(theta) + P(1);
line_y = (x-P(1)) * sind(theta) + (y-P(2)) * cosd(theta) + P(2);
plot(line_x, line_y, 'r-');
end