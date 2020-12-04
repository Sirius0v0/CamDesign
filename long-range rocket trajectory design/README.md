# 航天飞行动力学远程火箭弹道设计大作业 

已知火箭纵向运动方程式如公式所示。

![img](file:///D:\GitRepository\ProgrammingTraining\long-range rocket trajectory design\img\wps1.jpg)
$$
\left.\begin{array}{c}
\dot{v}=\frac{P_{e}}{m}+g \cdot \sin \theta \\
v \dot{\theta}=\frac{1}{m} \cdot P_{e} \cdot \alpha+g \cdot \cos \theta \\
\dot{x}=v \cdot \cos \theta \\
\dot{y}=v \cdot \sin \theta \\
m=m_{0}-\dot{m} \cdot t \\
\alpha=A_{\varphi} \cdot\left(\varphi_{p r}-\theta\right)
\end{array}\right\}
$$
其中，$v,P_e,m_0,\theta,\alpha,x,y$ 分别为火箭飞行速度、发动机的有效推力、火箭初始质量、弹道倾角、攻角、水平位移和飞行高度；$A_{\phi}$为角度增益系数，$t$为火箭飞行时间，$m$为火箭质量。仿真初始条件如表1和表2所示。

**表1初始状态**

| 序号 | 变量名   | 变量值          | 物理意义及单位                         |
| ---- | -------- | --------------- | -------------------------------------- |
| 0    | $t$      | 0               | 火箭飞行时间，s                        |
| 1    | $\theta$ | $\frac{\pi}{2}$ | 初始弹道倾角，弧度                     |
| 2    | $v$      | 0               | 火箭初始速度，单位$m/s$                |
| 4    | $x$      | 0               | 火箭在地面发射坐标系下的初始水平位置,m |
| 5    | $y$      | 0               | 火箭在地面发射坐标系下的初始高度,m     |

**表2 有关参数**

| 序号 | 变量名    | 变量值 | 物理意义及单位                |
| ---- | --------- | ------ | ----------------------------- |
| 1    | $\dot{m}$ | 28.57  | 单位时间燃料质量消耗， $kg/s$ |
| 2    | $g$       | 9.8    | 重力加速度常数， $N/s^2$      |
| 3    | $A_\phi$  | 35     | 角度增益系数                  |
| 4    | $P_e$     | 200    | 发动机推力，KN                |
| 5    | $m_0$     | 8000   | 起飞质量kg                    |
| 6    | W         | 7000   | 排气速度                      |

 

飞行程序角$\phi_{Pr}$随火箭飞行时间的关系如公式：
$$
\varphi_{p r}=\left\{\begin{array}{cc}
\frac{\pi}{2} & 0 \leq t<t_{1} \\
\frac{\pi}{2}+\left(\frac{\pi}{2}-f i g\right) \cdot\left[\left(\frac{t-t_{1}}{t_{2}-t_{1}}\right)^{2}-2 \cdot \frac{t-t_{1}}{t_{2}-t_{1}}\right] & t_1 \leq t<t_{2}\\
f i g & t_{2} \leq t \leq t_{3} \\
\end{array}\right.

\\
fig = \pi / 60, t_1 = 10s, t_2 = 130s,t_3 = 150s
$$
问题：（1）请根据如上已知条件，完成火箭纵向主动段运动轨迹仿真，绘出其速度、弹道倾角、质心位置变化曲线，并求出主动段终点参数速度、弹道倾角、质心位置的值。

（2）验证齐奥尔科夫斯基公式。