function fhtrack_deleteFhfunc(CurrentFhIdx)

global gh

% delete tracked centroids
for k = gh.data.cFrame:size(gh.data.ImRaw,3)
    gh.data.FhCentroid{k,1}(gh.param.CurrentFhIdx,1:2) = [0 0];
    gh.data.FhOrient{k,1}(gh.param.CurrentFhIdx,1) = 0;
end

gh.param.fhDeleteIdx = [gh.param.fhDeleteIdx CurrentFhIdx];
fhtrack_alert1;
set(gh.manualtrack.ChckbxDeleteFish,'Value',0);

fprintf('%s\n',['Deleted fish ' num2str(CurrentFhIdx)]);