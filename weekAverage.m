function averagedData=weekAverage(data)
n=7;
averagedData = arrayfun(@(i) mean(data(i:i+n-1)),1:n:length(data)-n+1)';
end