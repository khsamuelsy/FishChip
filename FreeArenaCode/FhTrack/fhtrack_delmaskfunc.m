function fhtrack_delmaskfunc(IdxMin)

global gh

if size(gh.data.ix,1) == 1
    gh.data.ix = [];
    gh.data.iy = [];
    gh.data.itheta = [];
    gh.data.LblMask = gh.data.LblMask - gh.data.LblMask;
else
    gh.data.ix(IdxMin) = [];
    gh.data.iy(IdxMin) = [];
    gh.data.itheta(IdxMin) = [];
    gh.data.LblMask(gh.data.LblMask==IdxMin) = 0;
    gh.data.LblMask(gh.data.LblMask>IdxMin) = gh.data.LblMask(gh.data.LblMask>IdxMin)-1;
end

if size(gh.data.ix,1) == 0
    gh.param.InferFlag = 0;
end