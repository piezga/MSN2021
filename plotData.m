function plotData(average_over_week,ISS,regione)
%plotData is a function.
%     plotData(average_over_week, ISS, regione)
%     default: (true,false,-)
%
%Gli argomenti permettono di scegliere se mediare i dati settimanalmente e
%se usare i dati dei sintomatici con data del primo sintomo dell'ISS oppure
%i dati della protezione civile.

if nargin<2
    ISS = false; %week average enabled
end
if nargin<1
    average_over_week = true; %week average enabled
end

load('.\data\andamento-nazionale.mat')
load('data\andamento-nazionale-ISS.mat')
load('.\data\calcolo_Rt_Italia.mat')
load('.\data\regioni.mat')
load('.\data\Rt_regioni_nonUfficiale.mat')


%Comparazione dell'andamento nazionale e dell'andamento di una data regione
%per quanto riguarda i nuovi casi giornalieri e il valore Rt. Usare
%average_over_week = true/false per mediare sulla settimana.


 %%
%Plotting andamento nazionale
plotNazionale = figure('NumberTitle', 'off', 'Name', 'Andamento nazionale');

if ISS
    data= casi_inizio_sintomi_sint.inizio_sintomi;
    nuoviPositivi = casi_inizio_sintomi_sint.casi;
    sgtitle('Andamento Nazionale (dati dell''ISS)')
else
    data = andamento_nazionale.data;
    nuoviPositivi = andamento_nazionale.nuovi_positivi;
    sgtitle('Andamento Nazionale (dati della Protezione Civile)')
 end





subplot(2,1,1) %andamento nuovi positivi

if average_over_week
    x=data(7:end);
    plot(x,weekAverage(nuoviPositivi),'LineWidth',1.125)
else
    x=data;
    plot(x,nuoviPositivi,'LineWidth',1.125)
end

hold on
xline(x(end-14),'--','Ultimi 14 giorni','Color',[0.9290 0.6940 0.1250])
xl=xlim;
xlim([xl(1) xl(2)-calmonths])
datetick('x')
        
ylabel("Nuovi positivi")

subplot(2,1,2) %andamento Rt

x=calcolo_Rt_Italia.data;
yu=calcolo_Rt_Italia.R_upperCI;
yl=calcolo_Rt_Italia.R_lowerCI;
y=calcolo_Rt_Italia.R_medio;

plot(x,yu,x,yl)

fill([x',fliplr(x')],[yl',fliplr(yu')],[0 0.4470 0.7410],'FaceAlpha','0.5','EdgeColor','none')
hold on
plot(x,y,'-','Color',[0 0.4470 0.7410],'LineWidth',1.125);
hold on
xline(x(end-14),'--','Ultimi 14 giorni','Color',[0.9290 0.6940 0.1250])
xl=xlim;
xlim([xl(1) xl(2)-calmonths])
datetick('x')
ylabel('R_t')

%%
if nargin == 3
    %plotting dell'andamento regionale
    titolo = 'Andamento '+string(regione);
    plotRegionale = figure('NumberTitle', 'off', 'Name', titolo);
    sgtitle(titolo)

    i = regioni.denominazione_regione == regione;

    x=regioni.data(i);

    subplot(2,1,1) %andamento nuovi positivi

    if average_over_week
        x=x(7:end);
        plot(x,weekAverage(regioni.nuovi_positivi(i)),'LineWidth',1.125)
    else
        plot(x,regioni.nuovi_positivi(i),'LineWidth',1.125)
    end
    hold on
    xline(x(end-14),'--','Ultimi 14 giorni','Color',[0.9290 0.6940 0.1250])
    xl=xlim;
    xlim([xl(1) xl(2)-calmonths])
    datetick('x')
    
    ylabel("Nuovi positivi")

    subplot(2,1,2) %andamento Rt

    i=Rt_regioni_nonUfficiale.regione ==regione;
    x=Rt_regioni_nonUfficiale.data(i);

    yu=Rt_regioni_nonUfficiale.High_90(i);
    yl=Rt_regioni_nonUfficiale.Low_90(i);
    y=Rt_regioni_nonUfficiale.ML(i);

    plot(x,yu,x,yl)

    fill([x',fliplr(x')],[yl',fliplr(yu')],[0 0.4470 0.7410],'FaceAlpha','0.5','EdgeColor','none')
    hold on
    plot(x,y,'-','Color',[0 0.4470 0.7410],'LineWidth',1.125);
    ylabel('R_t')
    hold on
    xline(x(end-14),'--','Ultimi 14 giorni','Color',[0.9290 0.6940 0.1250])
    xl=xlim;
    xlim([xl(1) xl(2)-calmonths])
    datetick('x')
end

end