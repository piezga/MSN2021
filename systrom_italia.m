%applicazione di systrom ai dati italiani

%genero il vettore k
load('.\data\andamento-nazionale.mat')
load('.\data\regioni.mat')
i=regioni.denominazione_regione == 'Emilia-Romagna';
casi = regioni.nuovi_positivi(i);
k = weekAverage(casi)';
%array per ogni possibile valore di Rt
rt_max = 12;
rt_range = linspace(0,rt_max,rt_max*100+1);

%gamma di battiston
gamma = 1/9;

%R nostro
dlnI=diff(log(andamento_nazionale.totale_positivi));
R_nostro=(weekAverage(dlnI) + gamma)/gamma;

%connessione tra lambda e rt
lam = k(1:end-1).*exp(gamma*(rt_range' - 1));


%calcolo la likelihood per ogni giorno e la normalizzo
likelihood = zeros(rt_max*100+1,numel(k)-1);

for i = 1:numel(k)- 1
    nndaylikelihood = poisspdf(round(k(i+1)),lam(:,i));
    daylikelihood = nndaylikelihood./sum(nndaylikelihood);
    likelihood(:,i) = daylikelihood;
end

%qual è il valore più probabile di Rt per ogni giorno?

[posteriors, loglikelihood] = get_posteriors(k, 0.2);
[likelyprob,index] = max(posteriors);
likelyvalues = rt_range(index);

conf_intervals = zeros(numel(k)-1,2);
for i = 1:numel(k)-1
    [low, high] = confinterval(likelihood(:,i),rt_range,0.9);
    conf_intervals(i,1) = low;
    conf_intervals(i,2) = high;
end



figure
hold on
plot(likelyvalues,'b','LineWidth',1.2)
x_ax = 1:numel(likelyvalues)-1;
xfill = [x_ax, fliplr(x_ax)];
yfill = [conf_intervals(:,1)',fliplr(conf_intervals(:,2)')];
fill(xfill,yfill,'b','edgecolor','none','facealpha',0.3)
hold off


function [posteriors, loglikelihood] = get_posteriors(data, sigma)
    gamma = 1/9;
    %array per ogni possibile valore di Rt
    rt_max = 12;
    rt_range = linspace(0,rt_max,rt_max*100+1);
    %(1) calcolo lambda
    lam = data(1:end-1).*exp(gamma*(rt_range' - 1));
    %(2) calcolo likelihood di ogni giorno
    likelihood = zeros(rt_max*100+1,numel(data)-1);
    for i = 1:numel(data)- 1
        daylikelihood = poisspdf(round(data(i+1)),lam(:,i));
        likelihood(:,i) = daylikelihood;
    end
    %(3) creo la matrice gaussiana (elemento ij: prob di saltare da Rt = j
    % a Rt = i) e la normalizzo sulle righe
    nnprocess_matrix = normpdf(rt_range', rt_range, sigma); 
    process_matrix = zeros(numel(rt_range),numel(rt_range));
    for i = 1:numel(rt_range)
        process_matrix(i,:) = nnprocess_matrix(i,:)./sum(nnprocess_matrix(i,:));
    end
    %(4) calcolo la prior iniziale normalizzata
    prior0 = ones(1,numel(rt_range))./numel(rt_range);
    % matrice che tiene le posterior per ogni giorno
    % la posterior del primo giorno è prior0
    posteriors = rt_range'.*zeros(1,numel(data));
    posteriors(:,1) = prior0;
    %applicazione iterativa della regola di Bayes
    loglikelihood = 0;
    for i = 2:numel(data)-1
        %nuova prior
        currentprior = posteriors(:,i-1)'.*process_matrix;
        %numeratore di bayes
        numerator = likelihood(:,i).*currentprior;
        %denominatore di bayes
        den = sum(numerator);
        %num/den
        posteriors(:,i) = numerator/den;
        
        loglikelihood = loglikelihood + log(den);
    end
end
    
    