function compareR(gamma,week_average,sovrapposto,regione,averageBefore,averageWindow)

load("data\andamento-nazionale.mat")
load('.\data\calcolo_Rt_Italia.mat')
load('.\data\regioni.mat')
load('.\data\Rt_regioni_nonUfficiale.mat')

if nargin<6
    averageWindow = 7; %nel caso di una media settimanale decide se
end
if nargin<5
    averageBefore = true; %nel caso di una media settimanale decide se 
                          %mediare subito sul numero di positivi o mediare dopo il calcolo ri Rt
end
if nargin<4
    regione = "Nazionale"; %dati con cui fare il paragone
end
if nargin<3
    sovrapposto = false; %dati con cui fare il paragone
end
if nargin<2
    week_average = true; %week average abilitato di default
end
if nargin<1
    gamma=1/9;
end



if regione == "Nazionale"
    
    %DATI NAZIONALI
    
    figure('NumberTitle', 'off', 'Name', 'Andamento di R_t nazionale');
    sgtitle('Andamento di R_t nazionale')


    %plot dell'andamento di R calcolato con l'algoritmo dell' ISS
    
    %l'algoritmo autonomamente media i dati su finestra settimanale per cui
    %non è necessario applicare weekAverage
    
    if ~sovrapposto; subplot(2,1,2); end
        
    x=calcolo_Rt_Italia.data;
    yu=calcolo_Rt_Italia.R_upperCI;
    yl=calcolo_Rt_Italia.R_lowerCI;
    y=calcolo_Rt_Italia.R_medio;

    

    fill([x',fliplr(x')],[yl',fliplr(yu')],[0 0.4470 0.7410],'FaceAlpha','0.5','EdgeColor','none')
    hold on
    p2=plot(x,y,'-','Color',[0 0.4470 0.7410],'LineWidth',1.125);
    
    hold on
    
    %plot dell'andamento di R calcolato da noi
    if ~sovrapposto; subplot(2,1,1); end

    if week_average
        myData=andamento_nazionale.data(averageWindow:end);
        if averageBefore
            myR=Rt(weekAverage(andamento_nazionale.totale_positivi,averageWindow),gamma);
        else
            myR=weekAverage(Rt(andamento_nazionale.totale_positivi,gamma),averageWindow);
        end
        p1=plot(myData(2:end), myR,'-','Color','#D95319','LineWidth',1.125);
        hold on
        %plot(myData(2:end), myR,".",'Color','#0072BD')
    else
        myData=andamento_nazionale.data;
        myR=Rt(andamento_nazionale.totale_positivi,gamma);
        p1=plot(myData(2:end), myR,'-','Color','#D95319','LineWidth',1.125);
    end

    ylabel('R_t')
    
    
    if ~sovrapposto
        subplot(2,1,1)
        title("Modello SIR (lezione)")
        
        subplot(2,1,2)
        ylabel('R_t')
        title("Algoritmo ISS")
    else
        legend([p1,p2],["Modello SIR (lezione)","Algoritmo ISS"])
    end
    
else
    
    %DATI REGIONALI
   
    figure('NumberTitle', 'off', 'Name', 'Andamento di R_t in '+string(regione));
    sgtitle('Andamento di R_t in '+string(regione))
   
    %plot dell'andamento di R calcolato con l'algoritmo di K. Systrom
    
    %Systrom applica già un filtro Gaussiano, non c'è bisogno di mediare
    
    
    i=Rt_regioni_nonUfficiale.regione ==regione;
    dataRegione=Rt_regioni_nonUfficiale.data(i);
    
    if ~sovrapposto; subplot(2,1,2); end
    
    yu=Rt_regioni_nonUfficiale.High_90(i);
    yl=Rt_regioni_nonUfficiale.Low_90(i);
    y=Rt_regioni_nonUfficiale.ML(i);
    x=dataRegione;

    fill([x',fliplr(x')],[yl',fliplr(yu')],[0 0.4470 0.7410],'FaceAlpha','0.5','EdgeColor','none')
    hold on
    p2=plot(x,y,'-','Color',[0 0.4470 0.7410],'LineWidth',1.125);

    hold on
    
    %plot dell'andamento di R calcolato da noi

    i = regioni.denominazione_regione == regione;

    dataRegione=regioni.data(i);
    positiviRegione=regioni.nuovi_positivi(i);
    
    
    if ~sovrapposto; subplot(2,1,1); end

    if week_average
        myData=dataRegione(averageWindow:end);
        if averageBefore
            myR=Rt(weekAverage(positiviRegione,averageWindow),gamma);
        else
            myR=weekAverage(Rt(positiviRegione,gamma),averageWindow);
        end
        p1=plot(myData(2:end), myR,'Color','#D95319','LineWidth',1.124);
    else
        myData=dataRegione;
        myR=Rt(positiviRegione,gamma);
        p1=plot(myData(2:end), myR,'Color','#D95319','LineWidth',1.124);
    end

    ylabel('R_t')
    
    if ~sovrapposto
        subplot(2,1,1)
        title("Modello SIR (lezione)")
        
        subplot(2,1,2)
        ylabel('R_t')
        title("Algoritmo K. Systrom")
    else
        legend([p1,p2],["Modello SIR (lezione)","Algoritmo K. Systrom"])
    end
    
    
end
end
