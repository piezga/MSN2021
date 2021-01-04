function plotData(regione,average_over_week)
%Comparazione dell'andamento nazionale e dell'andamento di una data regione
%per quanto riguarda i nuovi casi giornalieri e il valore Rt. Usare
%average_over_week = true/false per mediare sulla settimana.

if nargin<2
    average_over_week = true; %week average enabled
end

load('.\data\andamento-nazionale.mat')
load('.\data\calcolo_Rt_Italia.mat')
load('.\data\regioni.mat')
load('.\data\Rt_regioni_nonUfficiale.mat')

wa=average_over_week; 

if wa
    n=7;
else
    n=1;
end
   
 %%
%Plotting andamento nazionale
plotNazionale = figure('NumberTitle', 'off', 'Name', 'Andamento nazionale');
sgtitle('Andamento nazionale')
x=andamento_nazionale.data(1:n:end-mod(length(andamento_nazionale.data),n));
subplot(2,1,1) %andamento nuovi positivi

if wa
    plot(x,weekAverage(andamento_nazionale.nuovi_positivi),".")
else
    plot(x,andamento_nazionale.nuovi_positivi)
end

ylabel("Nuovi positivi")

subplot(2,1,2) %andamento Rt
x=calcolo_Rt_Italia.data(1:n:end-mod(length(calcolo_Rt_Italia.data),n));

if wa
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
if wa
    plot(x,y,'.b')
end
ylabel('R_t')
%%
%plotting dell'andamento regionale
titolo = 'Andamento '+string(regione);
plotRegionale = figure('NumberTitle', 'off', 'Name', titolo);
sgtitle(titolo)

i = regioni.denominazione_regione == regione;

x=regioni.data(i);
x=x(1:n:end-mod(length(x),n));
subplot(2,1,1) %andamento nuovi positivi

if wa
    plot(x,weekAverage(regioni.nuovi_positivi(i)),".")
else
    plot(x,regioni.nuovi_positivi(i))
end

ylabel("Nuovi positivi")

subplot(2,1,2) %andamento Rt

i=Rt_regioni_nonUfficiale.regione ==regione;
x=Rt_regioni_nonUfficiale.data(i);
x=x(1:n:end-mod(length(x),n));

if wa
    yu=weekAverage(Rt_regioni_nonUfficiale.High_90(i));
    yl=weekAverage(Rt_regioni_nonUfficiale.Low_90(i));
    y=weekAverage(Rt_regioni_nonUfficiale.ML(i));
else
    yu=Rt_regioni_nonUfficiale.High_90(i);
    yl=Rt_regioni_nonUfficiale.Low_90(i);
    y=Rt_regioni_nonUfficiale.ML(i);
end
plot(x,yu,x,yl)

fill([x',fliplr(x')],[yl',fliplr(yu')],"b",'FaceAlpha','0.5','EdgeColor','none')
hold on
plot(x,y,'-');
if wa
    plot(x,y,'.b')
end
ylabel('R_t')


end