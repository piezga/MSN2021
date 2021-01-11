%%in [4] osservo k casi e voglio vedere la probabilità di lambda

k = 20;

lam = linspace(1,45,100);

likelihood = exp(-lam).*lam.^(k)/factorial(k);

%figure
% plot(lam,likelihood)

%%in [5]

k = [20, 40, 55, 90];

%array per ogni possibile valore di Rt
rt_range = linspace(0,12,1201);

%gamma di battiston
gamma = 1/9;

%connessione tra lamba e rt
lam = k(1:end-1).*exp(gamma*(rt_range' - 1));

%calcolo la likelihood per ogni giorno e la normalizzo

for i = 1:1201



