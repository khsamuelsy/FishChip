function fhtrack_swaptrajfunc

global gh

FhIdx1 = gh.param.SwapIdx(1);
FhIdx2 = gh.param.SwapIdx(2);

gh.param.SwapStartFrame = gh.data.cFrame;
set(gh.manualtrack.EditSwapStartFrame, 'String', num2str(gh.param.SwapStartFrame));

CoorTemp = gh.data.FhCoor{1,FhIdx1}(gh.param.SwapStartFrame:end,1:2);
gh.data.FhCoor{1,FhIdx1}(gh.param.SwapStartFrame:end,1:2) = gh.data.FhCoor{1,FhIdx2}(gh.param.SwapStartFrame:end,1:2);
gh.data.FhCoor{1,FhIdx2}(gh.param.SwapStartFrame:end,1:2) = CoorTemp; 

AngTemp = gh.data.FhAng{1,FhIdx1}(gh.param.SwapStartFrame:end,1);
gh.data.FhAng{1,FhIdx1}(gh.param.SwapStartFrame:end,1) = gh.data.FhAng{1,FhIdx2}(gh.param.SwapStartFrame:end,1);
gh.data.FhAng{1,FhIdx2}(gh.param.SwapStartFrame:end,1) = AngTemp; 

fhtrack_addmask2Im(gh.param.SwapStartFrame, gh.param.SwapIdx);

fhtrack_dispdrawfunc;