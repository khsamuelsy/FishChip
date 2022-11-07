function [OrderIdx] = fhtrack_findmindistcent(centOld, centNew, RepIdx, SepFlag)

OrderIdx = zeros(1,size(centOld, 1));

for k = 1:size(centOld, 1)
    if centOld(k,1) == 0
        OrderIdx(1,k) = nan;
    else
        centOldRep = repmat(centOld(k,:),size(centNew,1),1);
        coorDiff = centOldRep - centNew;
        coorDist = sqrt(coorDiff(:,1).^2 + coorDiff(:,2).^2);
        OrderIdx(1,k) = find(coorDist==min(coorDist));
        if any(RepIdx) && SepFlag && (sum(coorDist<20)>1)
            if RepIdx(1,k)
                centNew(OrderIdx(1,k),:) = nan;
            end
        end
    end
end
