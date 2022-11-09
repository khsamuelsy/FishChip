function ffica_find_dfof

global wholebrain

wholebrain.signal3 = wholebrain.signal;

% remove baseline
for i=1:size(wholebrain.signal,1)
    temp = wholebrain.signal(i,:);
    temp = [zeros(1,8),temp];
    baseline = temp;
    for j=9:length(temp)
        baseline(1,j) = min(temp(j-8:j));
    end
    baseline = baseline(9:end);
    ii=1;
    sessionbaseline = mean(wholebrain.signal(i,:));
    while ii<=size(wholebrain.signal,2)
        if mod(ii,wholebrain.exptlog.fps)==30
            sessionbaseline=baseline(ii);
        else
            baseline(ii)=sessionbaseline;
        end
        ii=ii+1;
    end
    wholebrain.signal3(i,:) =(wholebrain.signal(i,:) - baseline)./baseline;
end
