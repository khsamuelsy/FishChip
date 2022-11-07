function MaxAng = fhtrack_findfhangle(NewMaskPx,NewMaskPy,FrameNum)

global gh

ImPatch = gh.data.ImRaw(NewMaskPx-gh.param.HlfWid:NewMaskPx+gh.param.HlfWid,...
    NewMaskPy-gh.param.HlfWid:NewMaskPy+gh.param.HlfWid,FrameNum);

for k = 1:36
    CorrMtx = normxcorr2(1-gh.param.FhTemplateRot{1,(k-1)*10+1},ImPatch);
    gh.param.MaxCorr(k, 1) = max(CorrMtx(:));
end

MaxAng = 10*(mean(find(gh.param.MaxCorr==max(gh.param.MaxCorr))) - 1);