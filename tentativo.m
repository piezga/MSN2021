%%%%%%%%%%%in [4] osservo k casi e voglio vedere la probabilità di lambda

%k = 20;

%lam = linspace(1,45,100);

%likelihood = exp(-lam).*lam.^(k)/factorial(k);

%figure
% plot(lam,likelihood)

%%%%%%%%%%%%in [5]

k = [20, 40, 55, 90];

%array per ogni possibile valore di Rt
rt_max = 12;
rt_range = linspace(0,12,rt_max*100+1);

%gamma
gamma = 1/7;

%connessione tra lamba e rt
lam = k(1:end-1).*exp(gamma*(rt_range' - 1));

%calcolo la likelihood per ogni giorno e la normalizzo
%%PROBLEMA

likelihood_matrix = ones(1201,3);
for j = 1:3
    likelihood = exp(-lam(:,j)).*(lam(:,j).^k(j))/factorial(k(j));
    nlikelihood = normalize(likelihood,'norm');
    likelihood_matrix(:,j) = likelihood_matrix(:,j).*nlikelihood;
end
figure
plot(rt_range,likelihood_matrix(:,1),rt_range,likelihood_matrix(:,2),rt_range,likelihood_matrix(:,3))
