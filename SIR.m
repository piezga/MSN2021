function [t,S,I,R] = SIR(c,beta,gamma,S0,I0,R0,tmax)
%Simulazione SIR a determinata condizione iniziale e parametri.
tspan=[0 tmax];
y0=[S0 I0 R0];
N=S0+I0+R0;
[t,y]=ode45(@(t,y) differentialSIR(t,y,c,beta,gamma,N), tspan, y0);
plot(t,y)

S=y(:,1);
I=y(:,2);
R=y(:,3);
end
function dYdt = differentialSIR(t,Y,c,beta,gamma,N)
dYdt=zeros(3,1);
S=Y(1);
I=Y(2);
R=Y(3);

epsilon=beta*c/N;
dYdt(1)=-epsilon*S*I;
dYdt(2)=epsilon*S*I-gamma*I;
dYdt(3)=gamma*I;

end