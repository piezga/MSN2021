load('.\data\andamento-nazionale.mat')
gamma = 1/9;

dlnI=diff(log(andamento_nazionale.totale_positivi));
Rt_nostro=(dlnI + gamma)/gamma;
plot(weekAverage(Rt_nostro),'r')
title('R_t come derivata logaritmica (IT)')
xlabel("Settimane dall'inizio")
ylabel("R_t")