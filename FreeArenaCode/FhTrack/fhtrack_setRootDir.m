function fhtrack_setRootDir

global gh

RootDir = uigetdir('C:\');

fhtrack_updateparam({'RootDir'},{RootDir});
