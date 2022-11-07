function fhtrack_getfilenamefunc

global gh

TempDir = cd;
cd(gh.param.RootDir);
[FileName,Folder] = uigetfile('*.tif');
cd(TempDir);

fhtrack_updateparam({'ExptDate'},{Folder(end-12:end-1)});
fhtrack_updateparam({'ExptIndex'},{FileName});
