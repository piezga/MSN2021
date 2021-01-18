function [low,high] = confinterval(data,domain,prob)
    totalprob = cumsum(data) - cumsum(data)';
    [highs,lows] = find(totalprob>prob);
    [best, bestindex] = min(highs-lows);
    bestcouple = [highs(bestindex),lows(bestindex)];
    if numel(bestcouple) == 0
        bestcouple = [1,10];
    end
    high = domain(bestcouple(1));
    low = domain(bestcouple(2));
end
    
    
    