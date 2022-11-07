function fhtrack_savefunc

global gh

% save last tracking
%gh.output.TransOffset = [gh.output.TransOffset;gh.data.TransOffset];

    
gh.output.FhCoor = [gh.output.FhCoor;gh.data.FhCoor];
gh.output.FhAng = [gh.output.FhAng;gh.data.FhAng];
% gh.output.MaxCorr = [gh.output.MaxCorr;gh.data.MaxCorr];

FhData = gh.output;
save([gh.param.RootDir,'\Fhtrack_output\',gh.param.ExptDate,'.mat'],'FhData');

%save([gh.param.RootDir,'\Fhtrack_output\',gh.param.ExptDate,'_',gh.param.ExptIndex(1:end-4),'.mat'],'FhData');