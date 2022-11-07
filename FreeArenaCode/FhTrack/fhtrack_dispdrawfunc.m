function fhtrack_dispdrawfunc

global gh

ImTemp = double(gh.data.ImRaw(:,:,gh.data.cFrame));   

ImCLimGamma = [gh.data.cMin, gh.data.cMax, gh.data.Gamma];
ImTemp = fhtrack_adjustcontrast(ImTemp, ImCLimGamma);
gh.data.cSlice=repmat(ImTemp,[1 1 3]);

if gh.param.InferFlag
    if get(gh.disp.ChckbxDispSF,'Value') && ~get(gh.disp.ChckbxColorCode,'Value')
        alpha = repmat(0.35*(gh.data.LblMask(:,:,gh.data.cFrame)>0), [1 1 3]);
        labels = single(label2rgb(gh.data.LblMask(:,:,gh.data.cFrame)>0, [1 0 0.4])/255);
        gh.data.cSlice = ((1-alpha).*gh.data.cSlice) + (alpha.*labels);
    else
        alpha=repmat(0.55*(gh.data.LblMask(:,:,gh.data.cFrame)>0),[1 1 3]);
        labels=single(label2rgb(gh.data.LblMask(:,:,gh.data.cFrame)*20)/255);
        gh.data.cSlice=((1-alpha).*gh.data.cSlice)+(alpha.*labels);
    end
end

set(gh.disp.ih,'CDATA',gh.data.cSlice);

if myIsField(gh.disp,'TextH')
    if size(gh.disp.TextH,2)>=1
        NumMasks = size(gh.disp.TextH,2);
        for ii=1:NumMasks
            delete(gh.disp.TextH{1,ii});
        end
    end
end
if get(gh.disp.ChckbxDispMaskNum,'Value')
    for k = 1:size(gh.data.FhCoor,2)
        if (size(gh.data.FhCoor{1,k},1) >= gh.data.cFrame) && (gh.data.FhCoor{1,k}(gh.data.cFrame,1) ~= 0)
            C=[0.85 0 0.25];
            gh.disp.TextH{1,k}=text(gh.data.FhCoor{1,k}(gh.data.cFrame,2)+10*round(sind(gh.data.FhAng{1,k}(gh.data.cFrame,1))),...
                gh.data.FhCoor{1,k}(gh.data.cFrame,1)+10*round(cosd(gh.data.FhAng{1,k}(gh.data.cFrame,1))),...
                num2str(k),'Parent',gh.disp.AxesMain,'color',C);
        else
            gh.disp.TextH{1,k} = [];
        end
    end
end