global gh

filename=str2num(gh.param.ExptIndex(1:end-4));
if filename~=1 & gh.param.batchNum~=1 
    load([gh.param.RootDir,'\Fhtrack_output\',gh.param.ExptDate,'.mat'])
    gh.output = FhData;
    gh.data.refcoor = FhData.refcoor; 
end