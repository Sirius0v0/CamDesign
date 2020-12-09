clear
clc
close all
%% ��һ��
%% ��ز���
dm = 28.57;     % kg/s
g = 9.8;        % N/s^2
A_phi = 35;     % �Ƕ�����ϵ��
Pe = 200e3;     % ���������� N
m0 = 8e3;       % ������� kg
W = 7000;       % �����ٶ�

%% ��ʼ״̬
theta_0 = pi/2;   % ��ʼ������� rad
v_0 = 1e-9;        % ��ʼ�ٶ� m/s
x_0 = 0;        % ��ʼˮƽλ�� m
y_0 = 0;        % ��ʼ�߶� m

%% ���г����Phi_pr ����ز�������
fig = pi/60;
t1 = 10;
t2 = 130;
t3 = 150;
ppr = @(t) (pi/2) * (t >= 0 && t < t1) +...
    ( pi/2 + (pi/2 - fig)*( ((t-t1)/(t2-t1))^2 - 2*(t-t1)/(t2-t1) ) ) * (t >= t1 && t < t2)+...
    fig * (t >= t2 && t <= t3);
args = [dm,g,A_phi,Pe,m0];
y0 = [theta_0; v_0; x_0; y_0];
tspan = [0 t3];

%% ���
[t,y] = ode45(@(t,y) odefcn(t,y,ppr,args), tspan, y0);
theta_fin = y(end,1);
V_fin = y(end,2);
x_fin = y(end,3);
y_fin = y(end,4);

%% ���ӻ�
figure(1)
plot(t,y(:,1),'k','linewidth',1)
grid on
title('�ٶ�v�仯����')
legend('�ٶ�v�仯����','Location','best')
xlabel('�������ʱ��(��λ:s)')
ylabel('��������ٶ�(��λ:m/s)')
fprintf('�������յ��������ٶ�Ϊ %.2f m/s\n',V_fin);

figure(2)
plot(t,rad2deg(y(:,2)),'k','linewidth',1)
grid on
title('������� \theta �仯����')
legend('������� \theta �仯����','Location','best')
xlabel('�������ʱ��(��λ:s)')
ylabel('�������(��λ:��)')
fprintf('�������յ����������Ϊ %.4f��\n',theta_fin);

figure(3)
plot(y(:,3),y(:,4),'k','linewidth',1)
grid on
title('����λ�ñ仯����')
legend('����λ�ñ仯����','Location','best')
xlabel('����ڵ��淢������ϵ�µ�ˮƽλ��(��λ:m)')
ylabel('����ڵ��淢������ϵ�µĸ߶�(��λ:m)')
fprintf('�������յ����ڵ��淢������ϵ�µ�����Ϊ(%.2f, %.2f)m\n',x_fin,y_fin);


%% �ڶ���
%% V_k = -V_r * ln(m_k/m_0)
m_k = m0 - dm * t3;
error = (V_fin+W*log(m_k/m0))/ V_fin;
fprintf('��֤��¶��Ʒ�˹����ʽ������Ϊ: %.2f%%\n',error*100);