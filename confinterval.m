function [low,high] = confinterval(data,domain,prob)
    totalprob = cumsum(data) - cumsum(data)';
    [highs,lows] = find(totalprob>prob);
    [best, bestindex] = min(highs-lows);
    bestcouple = [highs(bestindex),lows(bestindex)];
    high = domain(bestcouple(1));
    low = domain(bestcouple(2));
end
    
    
    