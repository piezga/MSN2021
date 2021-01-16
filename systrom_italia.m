%applicazione di systrom ai dati italiani

%genero il vettore k
load('.\data\andamento-nazionale.mat')
casi = andamento_nazionale.nuovi_positivi;
k = weekAverage(casi)';

%array per ogni possibile valore di Rt
rt_max = 12;
rt_range = linspace(0,rt_max,rt_max*100+1);

%gamma di battiston
gamma = 1/9;

%R nostro
dlnI=diff(log(andamento_nazionale.totale_positivi));
R_nostro=(dlnI + gamma)/gamma;

%connessione tra lambda e rt
lam = k(1:end-1).*exp(gamma*(rt_range' - 1));

%calcolo la likelihood per ogni giorno e la normalizzo
likelihood = zeros(rt_max*100+1,numel(k)-1);

for i = 1:numel(k)- 1
    nndaylikelihood = poisspdf(k(i+1),lam(:,i));
    daylikelihood = nndaylikelihood./sum(nndaylikelihood);
    likelihood(:,i) = daylikelihood;
end

%update bayesiana
nnposteriors = cumprod(likelihood,2);
posteriors = nnposteriors./sum(nnposteriors);

%qual � il valore pi� probabile di Rt per ogni giorno?
%per ora tralascio bayes

[likelyprob,index] = max(likelihood);
likelyvalues = rt_range(index);

plot(likelyvalues)