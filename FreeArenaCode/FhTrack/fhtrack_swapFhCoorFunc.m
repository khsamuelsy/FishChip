function fhtrack_swapFhCoorFunc(CursorP)

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

switch gh.param.TogFlag
    case 0
        gh.param.SwapIdx(1) = FhIdx;
        set(gh.manualtrack.EditSwapIdxA, 'String', num2str(FhIdx)); 
        gh.param.TogFlag = 1;
    case 1
        gh.param.SwapIdx(2) = FhIdx;
        set(gh.manualtrack.EditSwapIdxB, 'String', num2str(FhIdx));
        gh.param.TogFlag = 0;
end

gh.param.SwapStartFrame = gh.data.cFrame;
set(gh.manualtrack.EditSwapStartFrame, 'String', num2str(gh.param.SwapStartFrame));