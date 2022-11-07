function fhtrack_bttntrackallfunc

global gh

for FhIdx = 1:size(gh.data.ix,1)
    set(gh.disp.textTrackProgress,'String',['Tracking fish ' num2str(FhIdx) '/' num2str(size(gh.data.ix,1))]); pause(0.001);
    fhtrack_trackv10b(FhIdx, 2, 1);
end

set(gh.disp.textTrackProgress,'String','Tracking done');