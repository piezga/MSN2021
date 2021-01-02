function [t,S,I,R] = plotSIR(c,beta,gamma,S0,I0,R0,tmax)
tspan=[0 tmax];
y0=[S0 I0 R0];
N=S0+I0+R0;
[t,y]=ode45(@(t,y) SIR(t,y,c,beta,gamma,N), tspan, y0);
plot(t,y)

S=y(:,1);
I=y(:,2);
R=y(:,3);
end