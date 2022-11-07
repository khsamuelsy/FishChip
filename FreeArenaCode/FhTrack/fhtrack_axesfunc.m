function fhtrack_axesfunc(hObject,handles)

global gh

coordinates=get(gh.disp.AxesMain,'CurrentPoint');
gh.param.CursorP=round(fliplr(coordinates(1,1:2)));
gh.param.ClickType=get(gh.disp.figure1,'selectiontype');

if get(gh.disp.ChckbxRemoveMask,'Value') || get(gh.disp.ChckbxAddMask,'Value') || get(gh.disp.ChckbxAddRefObj,'Value')
    gh.data.cFrame = 1;
    set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
    set(gh.disp.SliderMain,'Value',0);
end

if get(gh.disp.ChckbxRemoveMask,'Value')
    DistMtx=squareform(pdist([[gh.data.ix gh.data.iy];gh.param.CursorP]));
    [DMin,IdxMin]=min(DistMtx(end,1:end-1));
    if DMin<gh.param.HlfWid
             fhtrack_delmaskfunc(IdxMin);
    end
elseif get(gh.disp.ChckbxAddMask,'Value')
    fhtrack_addmaskfunc(gh.param.CursorP);
elseif get(gh.disp.ChckbxAddRefObj,'Value')
    fhtrack_addrefobjfunc(gh.param.CursorP);
elseif get(gh.manualtrack.ChckbxDeleteFhCoor,'Value')
    fhtrack_deleteFhCoorfunc(gh.param.CursorP);
elseif get(gh.manualtrack.ChckbxManualTrack,'Value')
    fhtrack_addFhCoorfunc(gh.param.CursorP);
elseif get(gh.manualtrack.ChckbxDeleteFish,'Value')
    fhtrack_deleteFhCoorfunc(gh.param.CursorP);
    fhtrack_deleteFhfunc(gh.param.CurrentFhIdx);
elseif get(gh.manualtrack.ChckbxPickFh,'Value')
    fhtrack_swapFhCoorFunc(gh.param.CursorP);
end

fhtrack_dispdrawfunc;