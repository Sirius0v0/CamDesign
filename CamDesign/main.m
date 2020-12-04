function main()
    close all
    
    h_fig = figure('Name','解析法设计凸轮轮廓',...
        'MenuBar','None',...
        'ToolBar','None',...
        'Units','normalized',...
        'Position',[0.05 0.05 0.7 0.9]);
    
    ax_fig = axes('Parent',h_fig,...
        'Units','normalized',...
        'Position',[0.06, 0.08, 0.7, 0.85],...
        'XTick',[],...
        'YTick',[],...
        'Box','On');
    setappdata(h_fig,'ax_fig',ax_fig);
    
    pum = uicontrol('Style','popupmenu',...
        'Parent',h_fig,...
        'String',{'请选择设计的凸轮方案','正弦','自定义'},...
        'FontSize',10,...
        'Units','normalized',...
        'Position',[0.78, 0.45, 0.18, 0.2]);
    setappdata(h_fig,'pum',pum);
    
    btn1 = uicontrol('Style','pushbutton',...
        'Parent',h_fig,...
        'String','绘制凸轮轮廓',...
        'FontSize',14,...
        'Units','normalized',...
        'Position',[0.78,0.4,0.18,0.1],...
        'Callback',{@callback_btn1,h_fig});
    setappdata(h_fig,'btn1',btn1)
    
    btn2 = uicontrol('Style','pushbutton',...
        'Parent',h_fig,...
        'String','清除图像',...
        'FontSize',14,...
        'Units','normalized',...
        'Position',[0.78,0.1,0.18,0.1],...
        'Callback',{@callback_btn2,h_fig});
    setappdata(h_fig,'btn2',btn2)
    
    btn3 = uicontrol('Style','pushbutton',...
        'Parent',h_fig,...
        'String','凸轮运动规律曲线',...
        'FontSize',14,...
        'Units','normalized',...
        'Position',[0.78,0.25,0.18,0.1],...
        'Callback',{@callback_btn3,h_fig});
    setappdata(h_fig,'btn3',btn3)
end

function callback_btn3(~,~,h_fig)
    ax_fig = getappdata(h_fig,'ax_fig');
    delete(ax_fig.Children)
    pum = getappdata(h_fig,'pum');
    switch pum.Value
        case 1
            plot([],[],'Parent',ax_fig)
        case 2
            syms p
            h = 30;
            phi_0 = pi;
            s = h/2*(1-cos(pi/phi_0*p));
            v = diff(s);
            a = diff(v);
            phi_deg = 0:0.1:360;
            phi_rad = deg2rad(phi_deg);
            S_phi = subs(s,p,phi_rad);
            V_phi = subs(v,p,phi_rad);
            A_phi = subs(a,p,phi_rad);
            hold on
            SS = plot(phi_deg,S_phi,'b-');
            VV = plot(phi_deg,V_phi,'r--');
            AA = plot(phi_deg,A_phi,'k:');
            legend([SS,VV,AA],'位置','速度','加速度')
            set(ax_fig,'xtick',[0:30:400],'ytick',[-40:5:40])
            xlabel(ax_fig,'\delta/(°)')
            ylabel(ax_fig,'s/m v/ms^{-1} a/ms^{-2}')
            hold off
            axis normal
        case 3
            h = 30;
            phi_01 = 5*pi/6;
            phi_02 = 2*pi/3;
            phi_deg = 0:0.1:360;
            phi_rad = deg2rad(phi_deg);
            S_phi = [];
            V_phi = [];
            A_phi = [];
            for pp = phi_rad
                if (pp< 5*pi/6 && pp>= 0)
                    s = @(p)(h/phi_01*p);
                    v = h/phi_01;
                    a = 0;
                    S_phi = [S_phi,s(pp)];
                    V_phi = [V_phi,v];
                    A_phi = [A_phi,a];
                elseif (pp<pi && pp>=5*pi/6 )
                    s = h;
                    v = 0;
                    a = 0;
                    S_phi = [S_phi,s];
                    V_phi = [V_phi,v];
                    A_phi = [A_phi,a];
                elseif (pp>=pi && pp<4*pi/3)
                    s =@(p) (h-2*h/phi_02^2*(p-pi).^2);
                    v =@(p) 4*h/phi_02^2*(p-pi);
                    a = 4*h/phi_02^2;
                    S_phi = [S_phi,s(pp)];
                    V_phi = [V_phi,v(pp)];
                    A_phi = [A_phi,a];
                elseif (pp>=4*pi/3 && pp<5*pi/3)
                    s = @(p)(2*h/phi_02^2*(phi_02-p+pi).^2);
                    v =  @(p)-4*h/phi_02^2*(phi_02-p+pi);
                    a = 4*h/phi_02^2;
                    S_phi = [S_phi,s(pp)];
                    V_phi = [V_phi,v(pp)];
                    A_phi = [A_phi,a];
                else
                    s = 0;
                    v = 0;
                    a = 0;
                    S_phi = [S_phi,s];
                    V_phi = [V_phi,v];
                    A_phi = [A_phi,a];
                end
            end
            hold on
            SS = plot(phi_deg,S_phi,'b-');
            VV = plot(phi_deg,V_phi,'r--');
            AA = plot(phi_deg,A_phi,'k:');
            legend([SS,VV,AA],'位置','速度','加速度')
            set(ax_fig,'xtick',[0:30:400],'ytick',[-40:5:40])
            xlabel(ax_fig,'\delta/(°)')
            ylabel(ax_fig,'s/m v/ms^{-1} a/ms^{-2}')
            hold off
            axis normal
    end
end

function callback_btn2(~,~,h_fig)
    ax_fig = getappdata(h_fig,'ax_fig');
    delete(ax_fig.Children)
    set(ax_fig,'xtick',[],'ytick',[],'xlabel',[],'ylabel',[])
end

function callback_btn1(~,~,h_fig)
    ax_fig = getappdata(h_fig,'ax_fig');
    delete(ax_fig.Children)
    pum = getappdata(h_fig,'pum');
    switch pum.Value
        case 1
            plot([],[],'Parent',ax_fig)
        case 2
            h = 30;
            e = 10;
            rb = 35;
            rr = 15;
            phi_0 = pi;
            args = [h e rb rr];
            s = @(p) h/2*(1-cos(pi/phi_0*p));
            [x,y,xb,yb] = draw_cos(s, args);
            hold on
            guding = circle(0,0,1);
            guding.LineStyle = '-';
            guding.Color = 'k';
            ind = find(yb == max(yb));
            guding_g = circle(xb(ind),yb(ind),1);
            guding_g.LineStyle = '-';
            guding_g.Color = 'k';
            gunzi = circle(xb(ind),yb(ind),rr-0.8);
            gunzi.LineStyle = '-';
            gunzi.Color = 'm';
            real = plot(x,y,'k-','linewidth',1.5,'Parent',ax_fig);
            ideal = plot(xb,yb,'b:','linewidth',1,'Parent',ax_fig);
            base_c = circle(0,0,rb);
            legend([real,ideal,base_c,gunzi],'实际廓线','理论廓线','基圆','滚轮')
            set(ax_fig,'xtick',[-100:10:100],'ytick',[-100:10:100])
            xlabel(ax_fig,'X/mm')
            ylabel(ax_fig,'Y/mm')
            axis equal
        case 3
            h = 30;
            e = 10;
            rb = 35;
            rr = 15;
            phi_01 = 5*pi/6;
            phi_02 = 2*pi/3;
            args = [h e rb rr];
            s = @(p) (h/phi_01*p) .* (p< 5*pi/6 & p>= 0) + (h) .* (p<pi & p>=5*pi/6 )+...
                (h-2*h/phi_02^2*(p-pi).^2) .* (p>=pi & p<4*pi/3) +(2*h/phi_02^2*(phi_02-p+pi).^2) .* (p>=4*pi/3 & p<5*pi/3)+...
                (0) .* (p>=5*pi/3 & p<=2*pi);
            [x,y,xb,yb] = draw_cos(s, args);
            hold on
            plot(x,y,'k-',xb,yb,'r--','Parent',ax_fig)
            guding = circle(0,0,1);
            guding.LineStyle = '-';
            guding.Color = 'k';
            ind = find(yb == max(yb));
            guding_g = circle(xb(ind),yb(ind),1);
            guding_g.LineStyle = '-';
            guding_g.Color = 'k';
            gunzi = circle(xb(ind),yb(ind),rr-0.6);
            gunzi.LineStyle = '-';
            gunzi.Color = 'm';
            real = plot(x,y,'k-','linewidth',1.5,'Parent',ax_fig);
            ideal = plot(xb,yb,'b:','linewidth',1,'Parent',ax_fig);
            base_c = circle(0,0,rb);
            legend([real,ideal,base_c,gunzi],'实际廓线','理论廓线','基圆','滚轮')
            set(ax_fig,'xtick',[-100:10:100],'ytick',[-100:10:100])
            xlabel(ax_fig,'X/mm')
            ylabel(ax_fig,'Y/mm')
            axis equal
    end
end

function [x,y,xb,yb] = draw_cos(func, args)
%%%基本参数定义args = [h e rb rr]
h = args(1);     % 行程h = 100mm
e = args(2);     % 偏距e = 0mm
rb = args(3);   % 基圆半径150mm
rr = args(4);     % 滚子半径
s0 = (rb^2 -e^2)^0.5;   % 起始高度s0
delta = atan(s0/e);
phi = 0:0.001:2*pi;
s = [];
i = 1;
for p = phi
    s(i) = func(p); % s(i) = h/2*(1-cos(pi/phi_0*p));     
    i = i + 1;
end
[DsDp,~]= diff_ctr(s,0.05,1);
s = s(1:end-2);
phi = phi(1:end-2);
phi_1 = phi + delta;
xb = e*cos(phi_1) + (s + s0).*sin(phi_1);
yb = e*sin(phi_1) - (s + s0).*cos(phi_1);

DxbDp = (s0 + s).*cos(phi_1) + (DsDp - e).*sin(phi_1);
DybDp = (s0 + s).*sin(phi_1) - (DsDp - e).*cos(phi_1);

x = xb + rr*(-DybDp./(DxbDp.^2+DybDp.^2).^0.5);
y = yb + rr*(DxbDp./(DxbDp.^2+DybDp.^2).^0.5);

end

function [dy,dx] = diff_ctr(y,Dt,n)
%   数值微分函数
%   y = 待微分的数据； Dt 步长 ，一般取值0.05，n为求微分阶数
y1 = [y 0 0 0 0 0 0];
y2 = [0 y 0 0 0 0 0];
y3 = [0 0 y 0 0 0 0];
y4 = [0 0 0 y 0 0 0];
y5 = [0 0 0 0 y 0 0];
y6 = [0 0 0 0 0 y 0];
y7 = [0 0 0 0 0 0 y];

switch n
    case 1, dy = (-y1 + 8*y2 - 8*y4 + y5)/12/Dt;
    case 2, dy = (-y1 + 16*y2 - 30*y3 + 16*y4 - y5)/12/Dt^2;
    case 3, dy = (-y1 + 8*y2 - 13*y3 + 13*y5 - 8*y6 +y7)/8/Dt^3;
    case 4, dy = (-y1 + 12*y2 -39*y3 +56*y4-39*y5+12*y6-y7)/6/Dt^4;
end
dy = dy(5+2*(n>2):end-4-2*(n>2));
dx = ([2:length(dy)+1]+(n>2))*Dt;
% dy = dy(1:end-3);
% dx = dx(1:end-3);
end

function h = circle(x,y,r)
%  画圆函数
%  x,y为圆心坐标，r为圆半径
    theta=0:0.05:2*pi;
    c_x=x+r*cos(theta);
    c_y=y+r*sin(theta);
    h = plot(c_x,c_y,'r-.','linewidth',0.4);
    axis equal
end