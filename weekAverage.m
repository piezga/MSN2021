function averagedData = weekAverage(data,numeroGiorni)
if nargin<2
    numeroGiorni = 7; %La media è fatta sui 7 giorni della settimana ma è 
                      %possibile dare come argomento opzionale una finestra diversa
end
averagedData=zeros(length(data),numeroGiorni);

for i = 1:numeroGiorni
    averagedData(:,i)=circshift(data,i-1);
end
averagedData=mean(averagedData,2);
averagedData=averagedData(numeroGiorni:end);

end

