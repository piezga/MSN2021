function compareR(gamma,week_average,sovrapposto,regione)

load("data\andamento-nazionale.mat")
load('.\data\calcolo_Rt_Italia.mat')
load('.\data\regioni.mat')
load('.\data\Rt_regioni_nonUfficiale.mat')

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

if week_average
    n=7;
    gamma=gamma*7;
else
    n=1;
end
if regione == "Nazionale"
    
    %DATI NAZIONALI
    
    plotNazionale = figure('NumberTitle', 'off', 'Name', 'Andamento di R_t nazionale');
    sgtitle('Andamento di R_t nazionale')


    %plot dell'andamento di R calcolato da noi
    if ~sovrapposto; subplot(2,1,1); end

    %preparo l'array delle date (che cambia se medio sulla settimana o meno)
    myData=andamento_nazionale.data(1:n:end-mod(length(andamento_nazionale.data),n)); 

    if week_average
        myR=Rt(weekAverage(andamento_nazionale.totale_positivi),gamma);
        plot(myData(2:end), myR,'-','Color','#0072BD')
        hold on
        plot(myData(2:end), myR,".",'Color','#0072BD')
    else
        myR=Rt(andamento_nazionale.totale_positivi,gamma);
        plot(myData(2:end), myR)
    end

    ylabel('R_t')
    
    hold on


    %plot dell'andamento di R calcolato con l'algoritmo dell' ISS
    
    if ~sovrapposto; subplot(2,1,2); end
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
    

    fill([x',fliplr(x')],[yl',fliplr(yu')],"b",'FaceAlpha','0.5','EdgeColor','none')
    hold on
    plot(x,y,'-','Color','b');
    if week_average
        plot(x,y,'.b')
    end
    
    
    if ~sovrapposto
        subplot(2,1,1)
        title("Modello SIR (lezione)")
        
        subplot(2,1,2)
        ylabel('R_t')
        title("Algoritmo ISS")
    end
    
else
    
    %DATI REGIONALI
   
    plotRegionale = figure('NumberTitle', 'off', 'Name', 'Andamento di R_t in '+string(regione));
    sgtitle('Andamento di R_t in '+string(regione))


    i = regioni.denominazione_regione == regione;

    dataRegione=regioni.data(i);
    positiviRegione=regioni.nuovi_positivi(i);
    
    
    %plot dell'andamento di R calcolato da noi
    if ~sovrapposto; subplot(2,1,1); end

    %preparo l'array delle date (che cambia se medio sulla settimana o meno)
    myData=dataRegione(1:n:end-mod(length(dataRegione),n)); 

    if week_average
        myR=Rt(weekAverage(positiviRegione),gamma);
        plot(myData(2:end), myR,'-','Color','#0072BD')
        hold on
        plot(myData(2:end), myR,".",'Color','#0072BD')
    else
        myR=Rt(positiviRegione,gamma);
        plot(myData(2:end), myR)
    end

    ylabel('R_t')
    
    hold on


    %plot dell'andamento di R calcolato con l'algoritmo di K. Systrom
    
    week_average=false; %Systrom applica già un filtro Gaussiano, non c'è bisogno di mediare
    
    
    i=Rt_regioni_nonUfficiale.regione ==regione;
    dataRegione=Rt_regioni_nonUfficiale.data(i);
    
    if ~sovrapposto; subplot(2,1,2); end
    

    if week_average
        yu=weekAverage(Rt_regioni_nonUfficiale.High_90(i));
        yl=weekAverage(Rt_regioni_nonUfficiale.Low_90(i));
        y=weekAverage(Rt_regioni_nonUfficiale.ML(i));
        x=dataRegione(1:n:end-mod(length(dataRegione),7));
    else
        yu=Rt_regioni_nonUfficiale.High_90(i);
        yl=Rt_regioni_nonUfficiale.Low_90(i);
        y=Rt_regioni_nonUfficiale.ML(i);
        x=dataRegione;
    end
    

    fill([x',fliplr(x')],[yl',fliplr(yu')],"b",'FaceAlpha','0.5','EdgeColor','none')
    hold on
    plot(x,y,'-','Color','b');
    if week_average
        plot(x,y,'.b')
    end
    
    
    if ~sovrapposto
        subplot(2,1,1)
        title("Modello SIR (lezione)")
        
        subplot(2,1,2)
        ylabel('R_t')
        title("Algoritmo K. Systrom")
    end
    
    
end
end
