function fhtrack_addmask2Im(StartFrame, FhList)

global gh

gh.param.InferFlag = 1;

for FrameNum = StartFrame:size(gh.data.ImRaw,3)
    
    for MaskNum = FhList
        
        NewMaskP = gh.data.FhCoor{1,MaskNum}(FrameNum,:);
        ThetaTemp = gh.data.FhAng{1,MaskNum}(FrameNum,1);
        
        if FrameNum == 1
            gh.data.ix(end+1,1) = NewMaskP(1);
            gh.data.iy(end+1,1) = NewMaskP(2);
            gh.data.itheta(end+1,1) = ThetaTemp;
        end
        
        if NewMaskP(1) ~= 0 & NewMaskP(2)~=0
            for k = 0:1:3
                if k == 0
                    gh.data.LblMask(NewMaskP(1)-round(3*k*cosd(ThetaTemp))-1:NewMaskP(1)-round(3*k*cosd(ThetaTemp))+1,...
                        NewMaskP(2)-round(3*k*sind(ThetaTemp))-1:NewMaskP(2)-round(3*k*sind(ThetaTemp))+1,...
                        FrameNum) = MaskNum;
                else
                    gh.data.LblMask(NewMaskP(1)-round(3*k*cosd(ThetaTemp)),...
                        NewMaskP(2)-round(3*k*sind(ThetaTemp)),...
                        FrameNum) = MaskNum;
                end
            end
        end
        
    end
    
    if mod(FrameNum,100) == 0
        set(gh.disp.textTrackProgress,'String',['Added mask for ' num2str(FrameNum) '/' num2str(size(gh.data.ImRaw,3))]);
        pause(0.0001);
    end
end
