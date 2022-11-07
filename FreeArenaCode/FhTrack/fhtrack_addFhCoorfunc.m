function fhtrack_addFhCoorfunc(CursorP)

global gh

FhIdx = gh.param.CurrentFhIdx;

if isempty(find(gh.data.LblMask(:,:,gh.data.cFrame)==FhIdx))
    for k = 1:gh.param.nFrameApply
        gh.data.FhCoor{1,FhIdx}(gh.data.cFrame+k-1,1:2) = [CursorP(1) CursorP(2)];
        gh.data.LblMask(CursorP(1)-1:CursorP(1)+1,CursorP(2)-1:CursorP(2)+1,...
            gh.data.cFrame+k-1) = FhIdx;
    end
elseif numel(find(gh.data.LblMask(:,:,gh.data.cFrame)==FhIdx))==9
    vecTemp = gh.data.FhCoor{1,FhIdx}(gh.data.cFrame,1:2) - [CursorP(1) CursorP(2)];
    vecTemp = vecTemp/norm(vecTemp);
    angTemp = mod(360*atan2(vecTemp(2),vecTemp(1))/(2*pi),360);
    for k = 1:gh.param.nFrameApply
        gh.data.FhAng{1,FhIdx}(gh.data.cFrame+k-1,1) = round(angTemp/10)*10;
        for j = 1:3
            gh.data.LblMask(gh.data.FhCoor{1,FhIdx}(gh.data.cFrame+k-1,1)-round(3*j*cosd(angTemp)),...
                gh.data.FhCoor{1,FhIdx}(gh.data.cFrame+k-1,2)-round(3*j*sind(angTemp)),...
                gh.data.cFrame+k-1) = FhIdx;
        end
    end
    if (str2double(get(gh.disp.TextCFrame,'String'))+gh.param.nFrameApply) <= (size(gh.data.ImRaw,3))
        gh.data.cFrame = round(str2double(get(gh.disp.TextCFrame,'String')))+gh.param.nFrameApply;
        set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
        set(gh.disp.SliderMain,'Value',(gh.data.cFrame-1)/(size(gh.data.ImRaw,3)-1));
        
        gh.data.cMax=get(gh.disp.SliderCMax,'Value');
        gh.data.cMin=get(gh.disp.SliderCMin,'Value');
        gh.data.Gamma=get(gh.disp.SliderGamma,'Value');
    end
end

gh.param.fhDeleteIdx(gh.param.fhDeleteIdx==FhIdx) = [];

fhtrack_dispdrawfunc;