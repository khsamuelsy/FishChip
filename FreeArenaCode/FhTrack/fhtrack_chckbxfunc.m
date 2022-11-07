function fhtrack_chckbxfunc(panel,hObject)

global gh

ObjTag=['gh.' panel '.' get(hObject,'Tag')];
ChckbxList={'gh.disp.ChckbxAddMask';'gh.disp.ChckbxRemoveMask';'gh.disp.ChckbxAddRefObj';...
    'gh.manualtrack.ChckbxDeleteFhCoor';'gh.manualtrack.ChckbxManualTrack';...
    'gh.manualtrack.ChckbxDeleteFish';'gh.manualtrack.ChckbxPickFh'};

if get(hObject,'Value')
    for ii=1:size(ChckbxList,1)
        if ~strcmp(ObjTag,ChckbxList{ii,1})
            set(eval(ChckbxList{ii,1}),'Value',0);
        end
    end
end