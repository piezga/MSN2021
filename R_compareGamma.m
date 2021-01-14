function R_compareGamma(gammaMin, gammaMax,week_average)
load("data\andamento-nazionale.mat")

gMin=min([gammaMin,gammaMax]);
gMax=max([gammaMin,gammaMax]);

if nargin<3
    week_average = true; %week average abilitato di default
end


figure
hold on
ylabel('R_t')
title("Andamento di R_t al variare di \gamma")
leg=[];
for x = 1/gMax:1/gMin
    gamma=1/x;
    if week_average; gamma=gamma*7;end
    
    

    if week_average
        myData=andamento_nazionale.data(7:end);
        myR=Rt(weekAverage(andamento_nazionale.totale_positivi),gamma);
        plot(myData(2:end), myR)
    else
        myData=andamento_nazionale.data;
        myR=Rt(andamento_nazionale.totale_positivi,gamma);
        plot(myData(2:end), myR)
    end
   leg=[leg,"1/"+string(x)];
end
legend(leg)
end
