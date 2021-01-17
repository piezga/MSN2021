function fitGamma(tlower,tupper)

load("data\andamento-nazionale.mat")


R = andamento_nazionale.deceduti + andamento_nazionale.dimessi_guariti;


variazione_positivi = [0;diff(weekAverage(andamento_nazionale.totale_positivi))];
dRdt = weekAverage(andamento_nazionale.nuovi_positivi) - variazione_positivi;
I=weekAverage(andamento_nazionale.totale_positivi);
data = andamento_nazionale.data(7:end);

i = isbetween(data,tlower,tupper);

figure

plot(data(i),R(i))

figure
plot(I(i),dRdt(i))



[b,bint,~,~,stats] = regress(dRdt(i),I(i));
display(b)
display(bint)
display(stats)
hold on
plot(I,I*b)
hold on
plot(I,I*bint(1))
hold on
plot(I,I*bint(2))
hold off
end