function [UniqueFlag] = fhtrack_isunique(Centroids, rowNum)

CoorToCheck = Centroids(rowNum,:);
Centroids(rowNum,:) = [];

CoorToCheckRep = repmat(CoorToCheck,size(Centroids,1),1);
Dist = sum((CoorToCheckRep - Centroids).*(CoorToCheckRep - Centroids),2);

UniqueFlag = ~any(Dist==0);