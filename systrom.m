%%%%%%%%%%%%in [5]

k = [20, 40, 55, 90];

%array per ogni possibile valore di Rt
rt_max = 12;
rt_range = linspace(0,rt_max,rt_max*100+1);

%gamma
gamma = 1/7;

%connessione tra lambda e rt
lam = k(1:end-1).*exp(gamma*(rt_range' - 1));

%calcolo la likelihood per ogni giorno e la normalizzo

likelihood = zeros(rt_max*100+1,3);

for i = 1:3
    nndaylikelihood = poisspdf(k(i+1),lam(:,i));
    daylikelihood = nndaylikelihood./sum(nndaylikelihood);
    likelihood(:,i) = daylikelihood;
end

    
figure
plot(rt_range,likelihood)
title('No Bayes')
legend('Giorno 1','Giorno 2', 'Giorno 3')

%Bayes: cumprod(A,dim) con dim=2 per moltiplicare sulla stessa riga
nnposteriors = cumprod(likelihood,2);
posteriors = nnposteriors./sum(nnposteriors);

figure
plot(rt_range, posteriors)
title('Update bayesiana')
legend('Giorno 1','Giorno 2', 'Giorno 3')


%qual è il valore più probabile di Rt per ogni giorno?

[likelyprob,index] = max(posteriors);
likelyvalues = rt_range(index);

%confidence interval 
conf_intervals = zeros(3,2);
for i = 1:3
    [low, high] = confinterval(posteriors(:,i),rt_range,0.95);
    conf_intervals(i,1) = low;
    conf_intervals(i,2) = high;
end
conf_intervals