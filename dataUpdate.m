function dataUpdate
%Aggiornamento dei dataset sul covid (il calcolo di Rt secondo l'ISS va aggiornato manualmente
%eseguendo lo script MyCalcoloRt_epiEstim.R)
url="https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-andamento-nazionale.json";
websave('rawData\andamento-nazionale.txt',url,weboptions('ContentType','json'));
andamento_nazionale = jsondecode(fileread('rawData\andamento-nazionale.txt'));
fields = {'stato','ricoverati_con_sintomi','terapia_intensiva','totale_ospedalizzati','isolamento_domiciliare',
    'variazione_totale_positivi','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi','tamponi',
    'casi_testati','note','ingressi_terapia_intensiva','note_test','note_casi'};
andamento_nazionale = rmfield(andamento_nazionale,fields);
save("data\andamento-nazionale","andamento_nazionale")
disp("Aggiornato andamento_nazionale.mat")

url="https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-json/dpc-covid19-ita-regioni.json";
websave('rawData\regioni.txt',url,weboptions('ContentType','json'));
regioni = jsondecode(fileread('rawData\regioni.txt'));
fields = {'stato','ricoverati_con_sintomi','terapia_intensiva','totale_ospedalizzati','isolamento_domiciliare',
    'variazione_totale_positivi','casi_da_sospetto_diagnostico','casi_da_screening','totale_casi','tamponi',
    'casi_testati','note','ingressi_terapia_intensiva','note_test','note_casi'};
regioni = rmfield(regioni,fields);
regioni = rmfield(regioni,{'lat','long'});
save("data\regioni","regioni")
disp("Aggiornato regioni.mat")

url="https://raw.githubusercontent.com/Biuni/rt-italy/master/src/data/Rt.csv";
websave('rawData\Rt-regioni-nonUfficiale.csv',url);
Rt_regioni_nonUfficiale = table2struct(readtable('rawData\Rt-regioni-nonUfficiale.csv'));
save("data\Rt_regioni_nonUfficiale","Rt_regioni_nonUfficiale")
disp("Aggiornato Rt_regioni_nonUfficiale.mat")

url="https://www.epicentro.iss.it/coronavirus/open-data/calcolo_rt_italia.zip";
websave('rawData\calcolo_rt_italia.zip',url);
unzip('rawData\calcolo_rt_italia.zip','rawData\')
delete 'rawData\calcolo_Rt_Italia\.DS_store' 'rawData\calcolo_Rt_Italia.zip' 'rawData\calcolo_Rt_Italia\calcoloRt_EpiEstim.R'
rmdir  'rawData\__MACOSX' s
disp("Scaricato raw dataset calcolo_Rt_Italia. Per aggiornare il file .mat eseguire lo script MyCalcoloRt_EpiEstim.R e rieseguire questa funzione.")

calcolo_Rt_Italia = table2struct(readtable('rawData\calcolo_Rt_Italia\calcolo_Rt_Italia.csv'));
calcolo_Rt_Italia = rmfield(calcolo_Rt_Italia,'Var1');
save("data\calcolo_Rt_Italia","calcolo_Rt_Italia")
disp("Aggiornato calcolo_Rt_Italia.mat (a partire dai dati generati da MyCalcoloRt_EpiEstim.R)")

end
