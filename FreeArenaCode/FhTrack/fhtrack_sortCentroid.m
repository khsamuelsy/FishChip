function [centNew] = fhtrack_sortCentroid(centOld, OrderIdx)

centNew = zeros(size(centOld,1),size(centOld,2));
for k = 1:size(OrderIdx,2)
    if isnan(OrderIdx(1,k))
        centNew(k,:) = zeros(1,size(centOld,2));
    else
        centNew(k,:) = centOld(OrderIdx(k),:);
    end
end