function dataUpdate
%Aggiornamento dei dataset sul covid (il calcolo di Rt secondo l'ISS va aggiornato manualmente
%eseguendo lo script MyCalcoloRt_epiEstim.R)
%test test test a caso 


%Update andamento nazionale (protezione civile)
url="https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json";
websave('rawData\andamento-nazionale.txt',url,weboptions('ContentType','json'));
andamento_nazionale = jsondecode(fileread('rawData\andamento-nazionale.txt'));
fields = {'stato','ricoverati_con_sintomi','terapia_intensiva','totale_ospedalizzati','isolamento_domiciliare',
    'variazione_totale_positivi','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi','tamponi',
    'casi_testati','note','ingressi_terapia_intensiva','note_test','note_casi'};
andamento_nazionale = rmfield(andamento_nazionale,fields);
andamento_nazionale = struct('data',datetime(vertcat(andamento_nazionale.data),'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss'),...
                            'totale_positivi',vertcat(andamento_nazionale.totale_positivi), ...
                            'nuovi_positivi',vertcat(andamento_nazionale.nuovi_positivi), ...
                            'dimessi_guariti',vertcat(andamento_nazionale.dimessi_guariti), ...
                            'deceduti',vertcat(andamento_nazionale.deceduti));


save("data\andamento-nazionale","andamento_nazionale")
disp("Aggiornato andamento_nazionale.mat")

%Update andamento nazionale (ISS)
url="https://www.epicentro.iss.it/coronavirus/open-data/covid_19-iss.xlsx";
websave('rawData\covid_19-iss.xlsx',url);
[~, ~, casi_inizio_sintomi]=xlsread('rawData\covid_19-iss.xlsx','casi_inizio_sintomi');
[~, ~, casi_inizio_sintomi_sint]=xlsread('rawData\covid_19-iss.xlsx','casi_inizio_sintomi_sint');
casi_inizio_sintomi = casi_inizio_sintomi(2:end-1,:);
casi_inizio_sintomi_sint = casi_inizio_sintomi_sint(2:end-1,:);
casi_inizio_sintomi = cell2struct(casi_inizio_sintomi,{'data','inizio_sintomi','casi'},2);
casi_inizio_sintomi_sint = cell2struct(casi_inizio_sintomi_sint,{'data','inizio_sintomi','casi'},2);
casi_inizio_sintomi = struct('data',datetime(vertcat(casi_inizio_sintomi.data)),...
                            'inizio_sintomi',datetime(vertcat(casi_inizio_sintomi.inizio_sintomi)), ...
                            'casi',double(vertcat(char(casi_inizio_sintomi.casi))));
                   
casi_inizio_sintomi_sint = struct('data',datetime(vertcat(casi_inizio_sintomi_sint.data)),...
                            'inizio_sintomi',datetime(vertcat(casi_inizio_sintomi_sint.inizio_sintomi)), ...
                            'casi',double(vertcat(char(casi_inizio_sintomi_sint.casi))));

save("data\andamento-nazionale-ISS","casi_inizio_sintomi",'casi_inizio_sintomi_sint')
disp("Aggiornato andamento_nazionale-ISS.mat")

%Update andamento regioni
url="https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-regioni.json";
websave('rawData\regioni.txt',url,weboptions('ContentType','json'));
regioni = jsondecode(fileread('rawData\regioni.txt'));
fields = {'stato','ricoverati_con_sintomi','terapia_intensiva','totale_ospedalizzati','isolamento_domiciliare',
    'variazione_totale_positivi','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi','tamponi',
    'casi_testati','note','ingressi_terapia_intensiva','note_test','note_casi'};
regioni = rmfield(regioni,fields);
regioni = rmfield(regioni,{'lat','long'});
newDenominazione_regione = [];
for i=1:length(regioni)
    newDenominazione_regione = [newDenominazione_regione; string(regioni(i).denominazione_regione)];
end
regioni = struct('data',datetime(vertcat(regioni.data),'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss'),...
                            'codice_regione',vertcat(regioni.codice_regione), ...
                            'denominazione_regione',newDenominazione_regione, ...
                            'totale_positivi',vertcat(regioni.totale_positivi), ...
                            'nuovi_positivi',vertcat(regioni.nuovi_positivi), ...
                            'dimessi_guariti',vertcat(regioni.dimessi_guariti), ...
                            'deceduti',vertcat(regioni.deceduti));


save("data\regioni","regioni")
disp("Aggiornato regioni.mat")


%Update Rt regionale
url="https://raw.githubusercontent.com/Biuni/rt-italy/master/src/data/Rt.csv";
websave('rawData\Rt-regioni-nonUfficiale.csv',url);
Rt_regioni_nonUfficiale = table2struct(readtable('rawData\Rt-regioni-nonUfficiale.csv'));

newRegione = [];
for i=1:length(Rt_regioni_nonUfficiale)
    newRegione = [newRegione; string(Rt_regioni_nonUfficiale(i).state)];
end
Rt_regioni_nonUfficiale = struct('data',vertcat(Rt_regioni_nonUfficiale.date),...
                            'regione',newRegione, ...
                            'ML',vertcat(Rt_regioni_nonUfficiale.ML), ...
                            'Low_90',vertcat(Rt_regioni_nonUfficiale.Low_90), ...
                            'High_90',vertcat(Rt_regioni_nonUfficiale.High_90), ...
                            'Low_50',vertcat(Rt_regioni_nonUfficiale.Low_50), ...
                            'High_50',vertcat(Rt_regioni_nonUfficiale.High_50));

save("data\Rt_regioni_nonUfficiale","Rt_regioni_nonUfficiale")
disp("Aggiornato Rt_regioni_nonUfficiale.mat")



%Update Rt nazionale
url="https://www.epicentro.iss.it/coronavirus/open-data/calcolo_rt_italia.zip";
websave('rawData\calcolo_rt_italia.zip',url);
unzip('rawData\calcolo_rt_italia.zip','rawData\')
delete 'rawData\calcolo_Rt_Italia\.DS_store' 'rawData\calcolo_Rt_Italia.zip' 'rawData\calcolo_Rt_Italia\calcoloRt_EpiEstim.R'
rmdir  'rawData\__MACOSX' s
disp("Scaricato raw dataset calcolo_Rt_Italia. Per aggiornare il file .mat eseguire lo script MyCalcoloRt_EpiEstim.R e rieseguire questa funzione.")



calcolo_Rt_Italia = table2struct(readtable('rawData\calcolo_Rt_Italia\calcolo_Rt_Italia.csv'));
calcolo_Rt_Italia = rmfield(calcolo_Rt_Italia,'Var1');

calcolo_Rt_Italia = struct('data',vertcat(calcolo_Rt_Italia.data),...
                            'R_lowerCI',vertcat(calcolo_Rt_Italia.R_lowerCI), ...
                            'R_medio',vertcat(calcolo_Rt_Italia.R_medio), ...
                            'R_upperCI',vertcat(calcolo_Rt_Italia.R_upperCI));

save("data\calcolo_Rt_Italia","calcolo_Rt_Italia")
disp("Aggiornato calcolo_Rt_Italia.mat (a partire dai dati generati da MyCalcoloRt_EpiEstim.R)")

end
