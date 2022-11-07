function fhtrack_addrefobjfunc(NewMaskP)

global gh

% for displaying points marked
gh.data.LblMask(NewMaskP(1)-1:NewMaskP(1)+1,NewMaskP(2)-1:NewMaskP(2)+1,1) = 15;

% keep appending
gh.data.refcoor{1,end+1} = [NewMaskP(1) NewMaskP(2)];

if size(gh.data.refcoor,2)==1
    gh.param.InferFlag = 1;
end

% create refobj when done 4
if size(gh.data.refcoor,2)==4
    gh.data.refobjcoor = round((gh.data.refcoor{1,3}+gh.data.refcoor{1,4})/2);
%     gh.param.ImRefobj = gh.data.ImRaw(gh.data.refobjcoor(1,1)-375:gh.data.refobjcoor(1,1)+30,...
%         gh.data.refobjcoor(1,2)-60:gh.data.refobjcoor(1,2)+60,1);
    set(gh.disp.ChckbxAddRefObj,'Value',0);
end