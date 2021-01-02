function dYdt = SIR(t,Y,c,beta,gamma,N)
dYdt=zeros(3,1);
S=Y(1);
I=Y(2);
R=Y(3);

epsilon=beta*c/N;
dYdt(1)=-epsilon*S*I;
dYdt(2)=epsilon*S*I-gamma*I;
dYdt(3)=gamma*I;

end