clear
close all 
clc;

y0 = [1,1];
[tt1,yy1] = ode45(@odefun,[0,5],y0);
[tt2,yy2] = ode45(@odefun2,[0 5],y0);
[tt3,yy3] = ode45(@odefun3,[0 5],y0);
h = 0.001;
y1 = 1;
y2 = 1;
i = 1;
while(i~=5000)
    K21 = getdy2(y1(i),y2(i));  
    K22 = getdy2(y1(i),y2(i)+h/2*K21);
    K23 = getdy2(y1(i),y2(i)+h/2*K22);
    K24 = getdy2(y1(i),y2(i)+h*K23);
    y2(i+1) = y2(i) + h/6*(K21+2*K22+2*K23+K24);

    K11 = getdy1(y1(i),y2(i),y2(i+1));
    K12 = getdy1(y1(i)+h/2*K11,y2(i),y2(i+1));
    K13 = getdy1(y1(i)+h/2*K12,y2(i),y2(i+1));
    K14 = getdy1(y1(i)+h*K13,y2(i),y2(i+1)); 
    y1(i+1) = y1(i) + h/6*(K11+2*K12+2*K13+K14);
    
    i=i+1;
end
% figure(1)
% plot(tt2,yy2(:,1),linspace(0,5,5000),y1);
% legend('fun2','my');
% figure(2)
% plot(tt2,yy2(:,2),linspace(0,5,5000),y2);
% legend('fun2','my');
% plot(linspace(0,5,5000),y1,'linewidth',3)
% plot(linspace(0,5,5000),y2,'linewidth',3)
hold on
% plot(tt1,yy1(:,1))
plot(tt2,yy2(:,1))
plot(linspace(0,5,5000),y1,'linewidth',2)
figure(2)
plot(tt2,yy2(:,2))
plot(linspace(0,5,5000),y2)