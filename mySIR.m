function dydt = mySIR(t,y,c,bt,gm,N)

dydt = zeros(3,1);

dydt(1) = - bt * c/N * y(1)*y(2);
dydt(2) = bt * c/N * y(1)*y(2) - gm*y(2);
dydt(3) = gm*y(2);

end