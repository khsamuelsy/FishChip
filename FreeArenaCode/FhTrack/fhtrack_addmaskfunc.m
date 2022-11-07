function fhtrack_addmaskfunc(NewMaskP)

global gh

if size(gh.data.ix,1)==0
    gh.param.InferFlag = 1;
end

gh.data.ix(end+1,1) = NewMaskP(1);
gh.data.iy(end+1,1) = NewMaskP(2);
gh.data.itheta(end+1,1) = fhtrack_findfhangle(gh.data.ix(end),gh.data.iy(end),1);

for k = 0:1:3
    if k == 0
        gh.data.LblMask(NewMaskP(1)-round(3*k*cosd(gh.data.itheta(end)))-1:NewMaskP(1)-round(3*k*cosd(gh.data.itheta(end)))+1,...
            NewMaskP(2)-round(3*k*sind(gh.data.itheta(end)))-1:NewMaskP(2)-round(3*k*sind(gh.data.itheta(end)))+1,...
            1) = size(gh.data.ix,1);
    else
        gh.data.LblMask(NewMaskP(1)-round(3*k*cosd(gh.data.itheta(end))),...
            NewMaskP(2)-round(3*k*sind(gh.data.itheta(end))),...
            1) = size(gh.data.ix,1);
    end
end