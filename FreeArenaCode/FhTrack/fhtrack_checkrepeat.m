function [RepIdx] = fhtrack_checkrepeat(CentList)

DistMtx = squareform(pdist(CentList)==0);

RepIdx = min(DistMtx + eye(size(CentList,1)),[],1)==0;