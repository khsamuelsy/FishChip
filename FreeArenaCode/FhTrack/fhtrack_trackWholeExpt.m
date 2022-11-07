function fhtrack_trackWholeExpt(batchNum)

global gh

set(gh.disp.bttn_trackvidfunc,'Enable','off');

% save


fhtrack_cvloadfunc(0);

if batchNum == 2
    % translation of each image
    gh.output.TransOffset = [];
    % transformation for converting to metric scale and correct for shear
    gh.output.tformVec = gh.data.tformVec;
    gh.output.tformMtx = gh.data.tformMtx;
    gh.output.tformAffine = gh.data.tformAffine;
    % raw fish head coordinates / angles (after correct for translation)
    gh.output.FhCoor = [];
    gh.output.FhAng = [];
%     gh.output.MaxCorr = [];
    % save ref coor
    gh.output.refcoor = gh.data.refcoor;
end

fhtrack_savefunc;

% variable for transition
for k = 1:size(gh.data.FhCoor,2)
    gh.data.FhCoorTemp(k,:) = gh.data.FhCoor{1,k}(end,1:2);
    gh.data.FhCoor{1,k} = [];
end

% register images
fhtrack_imregv3(batchNum);

% % track fish
% for FhIdx = 1:size(gh.data.FhCoor,2)
%     
%     if sum(gh.param.fhDeleteIdx == FhIdx) == 0
%         
%         % variable for transition
%         gh.data.FhCoorTemp = gh.data.FhCoor{1,FhIdx}(end, 1:2);
%         gh.data.FhAngTemp = gh.data.FhAng{1, FhIdx}(end, 1);
%         
%         % re-initialize recorded coordinates / angles
%         gh.data.FhCoor{1,FhIdx} = [];
%         gh.data.FhAng{1,FhIdx} = [];
%         gh.data.MaxCorr{1,FhIdx} = [];
%         
%         % track
%         set(gh.disp.textTrackProgress,'String',['Tracking fish ' num2str(FhIdx) '/' num2str(size(gh.data.FhCoor,2))]); pause(0.001);
%         fhtrack_trackv10b(FhIdx, 1, batchNum);
%         
%     else
%         
%         % re-initialize recorded coordinates / angles
%         gh.data.FhCoor{1,FhIdx} = [];
%         gh.data.FhAng{1,FhIdx} = [];
%         gh.data.MaxCorr{1,FhIdx} = [];
%         
%     end
%     
% end

set(gh.disp.textTrackProgress,'String','');
set(gh.disp.bttn_trackvidfunc,'Enable','on');

% fhtrack_dispdrawfunc;