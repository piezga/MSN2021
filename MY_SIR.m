function [t,S,I,R] = MY_SIR(MYc,MYbt,MYgm,S0,I0,R0,T)

c = MYc;
bt = MYbt;
gm = MYgm;
N = S0+I0+R0;
tspan = [0 T];
y0 = [S0 I0 R0];
[t,y] = ode45(@(t,y) mySIR(t,y,c,bt,gm,N), tspan, y0);
plot(t,y)

S = y(:,1);
I = y(:,2);
R = y(:,3);

end