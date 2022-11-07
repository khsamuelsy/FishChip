function fhtrack_deleteFhCoorfunc(CursorP)

global gh

FhDist = zeros(1,size(gh.data.FhCoor,2));
for FhIdx = 1:size(gh.data.FhCoor,2)
    if gh.data.cFrame>size(gh.data.FhCoor{1,FhIdx},1)
        FhDist(1,FhIdx) = nan;
    else
        FhDist(1,FhIdx) = norm(CursorP - gh.data.FhCoor{1,FhIdx}(gh.data.cFrame,1:2));
    end
end
FhIdx = find(FhDist==min(FhDist),1);
gh.param.CurrentFhIdx = FhIdx;

% delete assigned coordinates and angles
gh.data.FhCoor{1,FhIdx}(gh.data.cFrame:end,:) = 0;
gh.data.FhAng{1,FhIdx}(gh.data.cFrame:end) = 0;

% delete from masks
LblMaskTemp = gh.data.LblMask(:,:,gh.data.cFrame:end);
LblMaskTemp(LblMaskTemp==gh.param.CurrentFhIdx) = 0;
gh.data.LblMask(:,:,gh.data.cFrame:end) = LblMaskTemp;

set(gh.manualtrack.TextCurrentFhIdx,'String',num2str(gh.param.CurrentFhIdx));

set(gh.manualtrack.ChckbxDeleteFhCoor,'Value',0);

fhtrack_alert1;
fhtrack_dispdrawfunc;