function compareR(gamma,week_average)

load("data\andamento-nazionale.mat")
load('.\data\calcolo_Rt_Italia.mat')

if nargin<2
    week_average = true; %week average abilitato di default
end
if nargin<1
    gamma=1/9;
end

if week_average
    n=7;
    gamma=gamma*7;
else
    n=1;
end

plotNazionale = figure('NumberTitle', 'off', 'Name', 'Andamento di R_t nazionale');
sgtitle('Andamento di R_t nazionale')


%plot dell'andamento di R calcolato da noi
subplot(2,1,1)

%preparo l'array delle date (che cambia se medio sulla settimana o meno)
myData=andamento_nazionale.data(1:n:end-mod(length(andamento_nazionale.data),n)); 

if week_average
    myR=Rt(weekAverage(andamento_nazionale.totale_positivi),gamma);
    plot(myData(2:end), myR,"." )
else
    myR=Rt(andamento_nazionale.totale_positivi,gamma);
    plot(myData(2:end), myR)
end

ylabel('R_t')
title("Modello SIR (lezione)")



%plot dell'andamento di R calcolato con l'algoritmo dell' ISS
subplot(2,1,2)
x=calcolo_Rt_Italia.data(1:n:end-mod(length(calcolo_Rt_Italia.data),n));

if week_average
    yu=weekAverage(calcolo_Rt_Italia.R_upperCI);
    yl=weekAverage(calcolo_Rt_Italia.R_lowerCI);
    y=weekAverage(calcolo_Rt_Italia.R_medio);
else
    yu=calcolo_Rt_Italia.R_upperCI;
    yl=calcolo_Rt_Italia.R_lowerCI;
    y=calcolo_Rt_Italia.R_medio;
end
plot(x,yu,x,yl)

fill([x',fliplr(x')],[yl',fliplr(yu')],"b",'FaceAlpha','0.5','EdgeColor','none')
hold on
plot(x,y,'-');
if week_average
    plot(x,y,'.b')
end
ylabel('R_t')
title("Algoritmo ISS")
end
