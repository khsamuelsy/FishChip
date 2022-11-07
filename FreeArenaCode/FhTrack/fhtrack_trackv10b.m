function fhtrack_trackv10b(FhIdx, bgnFrameIdx, batchNum)

global gh

if bgnFrameIdx == 1
    FhCoorTemp = gh.data.FhCoorTemp;
    xRangeTemp = FhCoorTemp(1)-gh.param.HlfWid:FhCoorTemp(1)+gh.param.HlfWid;
    yRangeTemp = FhCoorTemp(2)-gh.param.HlfWid:FhCoorTemp(2)+gh.param.HlfWid;
    FhAngTemp = gh.data.FhAngTemp;
elseif bgnFrameIdx == 2
    gh.data.FhCoor{1, FhIdx}(1,1:2) = [gh.data.ix(FhIdx) gh.data.iy(FhIdx)];
    FhCoorTemp = [gh.data.ix(FhIdx) gh.data.iy(FhIdx)];
    xRangeTemp = FhCoorTemp(1)-gh.param.HlfWid:FhCoorTemp(1)+gh.param.HlfWid;
    yRangeTemp = FhCoorTemp(2)-gh.param.HlfWid:FhCoorTemp(2)+gh.param.HlfWid;
    gh.data.FhAng{1, FhIdx}(1,1) = gh.data.itheta(FhIdx);
elseif bgnFrameIdx > 2
    FhCoorTemp = gh.data.FhCoor{1,FhIdx}(bgnFrameIdx-1,1:2);
    xRangeTemp = FhCoorTemp(1)-gh.param.HlfWid:FhCoorTemp(1)+gh.param.HlfWid;
    yRangeTemp = FhCoorTemp(2)-gh.param.HlfWid:FhCoorTemp(2)+gh.param.HlfWid;
    FhAngTemp = round(gh.data.FhAng{1,FhIdx}(bgnFrameIdx-1,1));
end

for FrameNum = bgnFrameIdx:size(gh.data.ImRaw,3)
    
    try
        
        ImPatch = fhtrack_NormIm(single(gh.data.ImRaw(xRangeTemp,yRangeTemp,FrameNum)));
        
        if FrameNum >= 2
            FhAngTemp = gh.data.FhAng{1, FhIdx}(FrameNum-1, 1);
            FhCoorTemp = gh.data.FhCoor{1, FhIdx}(FrameNum-1, 1:2);
        end

        CorrMtx = cell(1,5);
        MaxCorrTemp = zeros(3,1);
        for k = [0,-1,1]
            CorrMtx{1,k+2} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+k*20,360)+1},ImPatch);
            MaxCorrTemp(k+2,1) = max(CorrMtx{1,k+2}(:));
            if MaxCorrTemp(2,1)>0.9
                break;
            end
        end
        AngIdxTemp = find(MaxCorrTemp==max(MaxCorrTemp));
        if numel(AngIdxTemp)>1
            if any(AngIdxTemp==2)
                AngIdxTemp = 2;
            else
                AngIdxTemp = AngIdxTemp(1);
            end
        end

        switch AngIdxTemp
            case {1,3}
                CorrMtx{1,4} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+2*(AngIdxTemp-2)*20,360)+1},ImPatch);
                MaxCorrTemp(4,1) = max(CorrMtx{1,4}(:));
                if MaxCorrTemp(4,1) > MaxCorrTemp(AngIdxTemp,1)
                    CorrMtx{1,5} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+3*(AngIdxTemp-2)*20,360)+1},ImPatch);
                    MaxCorrTemp(5,1) = max(CorrMtx{1,5}(:));
                    if MaxCorrTemp(5,1) > MaxCorrTemp(4,1)
                        DiffAng1 = 3*(AngIdxTemp-2)*20;
                        MaxCorrCurrent = MaxCorrTemp(5,1);
                        CorrMtxFin = CorrMtx{1,4};
                    else
                        DiffAng1 = 2*(AngIdxTemp-2)*20;
                        MaxCorrCurrent = MaxCorrTemp(4,1);
                        CorrMtxFin = CorrMtx{1,4};
                    end
                else
                    DiffAng1 = (AngIdxTemp-2)*20;
                    MaxCorrCurrent = MaxCorrTemp(AngIdxTemp,1);
                    CorrMtxFin = CorrMtx{1,AngIdxTemp};
                end
            case 2
                DiffAng1 = 0;
                MaxCorrCurrent = MaxCorrTemp(2,1);
                CorrMtxFin = CorrMtx{1,2};
        end
        
        if DiffAng1 ~= 0
            CorrMtxFine = cell(1,2);
            MaxCorrTempFine = zeros(2,1);
            for k = DiffAng1-10:20:DiffAng1+10
                CorrMtxFine{1,ceil((k-DiffAng1+11)/20)} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+k,360)+1},ImPatch);
                MaxCorrTempFine(ceil((k-DiffAng1+11)/20),1) = max(CorrMtxFine{1,ceil((k-DiffAng1+11)/20)}(:));
            end
            AngIdxTemp = find(MaxCorrTempFine>MaxCorrCurrent);
            if isempty(AngIdxTemp)
                DiffAng = DiffAng1;
            elseif AngIdxTemp == 1
                DiffAng = DiffAng1-10;
                CorrMtxFin = CorrMtxFine{1,1};
                MaxCorrCurrent = max(CorrMtxFine{1,1}(:));
            elseif AngIdxTemp == 2
                DiffAng = DiffAng1+10;
                CorrMtxFin = CorrMtxFine{1,2};
                MaxCorrCurrent = max(CorrMtxFine{1,2}(:));
            end
        else
            DiffAng = DiffAng1;
        end
        
        if (MaxCorrCurrent>0.6)
            
            % record best correlation of template and fish image at tracked new location
            gh.data.MaxCorr{1,FhIdx}(FrameNum,1) = MaxCorrCurrent;
            
            % update angle
            gh.data.FhAng{1, FhIdx}(FrameNum,1) = mod(FhAngTemp + round(DiffAng), 360);
            
            % update coor
            [xPeakTemp, yPeakTemp] = ind2sub(size(CorrMtxFin), find(CorrMtxFin==max(CorrMtxFin(:))));
            VecOffsetTemp = [xPeakTemp(1) yPeakTemp(1)] - size(gh.param.FhTemplateRot{1,gh.data.FhAng{1, FhIdx}(FrameNum,1)+1})...
                + gh.param.FhTemplateHeadPt(gh.data.FhAng{1, FhIdx}(FrameNum,1)+1,:) - gh.param.HlfWid*[1 1] - 1;
            gh.data.FhCoor{1, FhIdx}(FrameNum, 1:2) = FhCoorTemp + VecOffsetTemp;
            
            % check if need to reverse by 180 deg
            if (abs(DiffAng)>60)
                reverseFlag = fhtrack_fhcheckreversal(FhCoorTemp, gh.data.FhCoor{1,FhIdx}(FrameNum,:),...
                    FhAngTemp,gh.data.FhAng{1, FhIdx}(FrameNum,1));
                if reverseFlag
                    gh.data.FhCoor{1, FhIdx}(FrameNum, 1:2) = [gh.data.FhCoor{1, FhIdx}(FrameNum,1)-round(10*cosd(gh.data.FhAng{1, FhIdx}(FrameNum,1))),...
                        gh.data.FhCoor{1, FhIdx}(FrameNum,2)-round(10*sind(gh.data.FhAng{1, FhIdx}(FrameNum,1)))];
                    gh.data.FhAng{1, FhIdx}(FrameNum,1) = mod(gh.data.FhAng{1, FhIdx}(FrameNum,1)+180,360);
                end
            end
            
            % update pixel range
            xRangeTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,1)-gh.param.HlfWid:gh.data.FhCoor{1, FhIdx}(FrameNum,1)+gh.param.HlfWid;
            yRangeTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,2)-gh.param.HlfWid:gh.data.FhCoor{1, FhIdx}(FrameNum,2)+gh.param.HlfWid;
            
            % mark in mask (for display)
            for k = 0:1:3
                xTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,1)-round(3*k*cosd(gh.data.FhAng{1, FhIdx}(FrameNum,1)));
                yTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,2)-round(3*k*sind(gh.data.FhAng{1, FhIdx}(FrameNum,1)));
                if k == 0
                    gh.data.LblMask(xTemp-1:xTemp+1,...
                        yTemp-1:yTemp+1,...
                        FrameNum) = FhIdx;
                else
                    gh.data.LblMask(xTemp,...
                        yTemp,...
                        FrameNum) = FhIdx;
                end
            end
            
        else
            
            % perform more extensive searching
            ImPatch = fhtrack_NormIm(single(gh.data.ImRaw(min(xRangeTemp)-2:max(xRangeTemp)+2,min(yRangeTemp)-2:max(yRangeTemp)+2,FrameNum)));
            
            CorrMtxExt = cell(1,10);
            MaxCorrTempExt = zeros(10,1);
            for k = 20:20:300
                CorrMtxExt{1,round(k/20)} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+k,360)+1},ImPatch);
                MaxCorrTempExt(round(k/20),1) = max(CorrMtxExt{1,round(k/20)}(:));
            end
            AngIdxTemp = find(MaxCorrTempExt==max(MaxCorrTempExt),1);
            
            DiffAng1 = AngIdxTemp*20;
            MaxCorrCurrent = MaxCorrTempExt(AngIdxTemp,1);
            CorrMtxFin = CorrMtxExt{1,AngIdxTemp};
            
            CorrMtxFine = cell(1,2);
            MaxCorrTempFine = zeros(2,1);
            for k = DiffAng1-10:20:DiffAng1+10
                CorrMtxFine{1,ceil((k-DiffAng1+11)/20)} = normxcorr2(1-gh.param.FhTemplateRot{1,mod(FhAngTemp+k,360)+1},ImPatch);
                MaxCorrTempFine(ceil((k-DiffAng1+11)/20),1) = max(CorrMtxFine{1,ceil((k-DiffAng1+11)/20)}(:));
            end
            
            AngIdxTemp = find(MaxCorrTempFine>MaxCorrCurrent);
            if isempty(AngIdxTemp)
                DiffAng = DiffAng1;
            elseif AngIdxTemp == 1
                DiffAng = DiffAng1-10;
                CorrMtxFin = CorrMtxFine{1,1};
                MaxCorrCurrent = max(CorrMtxFine{1,1}(:));
            elseif AngIdxTemp == 2
                DiffAng = DiffAng1+10;
                CorrMtxFin = CorrMtxFine{1,2};
                MaxCorrCurrent = max(CorrMtxFine{1,2}(:));
            end
            
            % record best correlation of template and fish image at tracked new location
            gh.data.MaxCorr{1,FhIdx}(FrameNum,1) = MaxCorrCurrent;
            
            % update angle
            gh.data.FhAng{1, FhIdx}(FrameNum,1) = mod(FhAngTemp + round(DiffAng), 360);
            
            % update coor
            [xPeakTemp, yPeakTemp] = ind2sub(size(CorrMtxFin), find(CorrMtxFin==max(CorrMtxFin(:))));
            VecOffsetTemp = [xPeakTemp yPeakTemp] - size(gh.param.FhTemplateRot{1,gh.data.FhAng{1, FhIdx}(FrameNum,1)+1})...
                + gh.param.FhTemplateHeadPt(gh.data.FhAng{1, FhIdx}(FrameNum,1)+1,:) - gh.param.HlfWid*[1 1] - 1;
            gh.data.FhCoor{1, FhIdx}(FrameNum, 1:2) = FhCoorTemp + VecOffsetTemp;
            
            % check if need to reverse by 180 deg
            if (abs(DiffAng)>60)
                reverseFlag = fhtrack_fhcheckreversal(FhCoorTemp, gh.data.FhCoor{1,FhIdx}(FrameNum,:),...
                    FhAngTemp,gh.data.FhAng{1, FhIdx}(FrameNum,1));
                if reverseFlag
                    gh.data.FhCoor{1, FhIdx}(FrameNum, 1:2) = [gh.data.FhCoor{1, FhIdx}(FrameNum,1)-round(10*cosd(gh.data.FhAng{1, FhIdx}(FrameNum,1))),...
                        gh.data.FhCoor{1, FhIdx}(FrameNum,2)-round(10*sind(gh.data.FhAng{1, FhIdx}(FrameNum,1)))];
                    gh.data.FhAng{1, FhIdx}(FrameNum,1) = mod(gh.data.FhAng{1, FhIdx}(FrameNum,1)+180,360);
                end
            end
            
            % update pixel range
            xRangeTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,1)-gh.param.HlfWid:gh.data.FhCoor{1, FhIdx}(FrameNum,1)+gh.param.HlfWid;
            yRangeTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,2)-gh.param.HlfWid:gh.data.FhCoor{1, FhIdx}(FrameNum,2)+gh.param.HlfWid;
            
            % mark in mask (for display)
            for k = 0:1:3
                xTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,1)-round(3*k*cosd(gh.data.FhAng{1, FhIdx}(FrameNum,1)));
                yTemp = gh.data.FhCoor{1, FhIdx}(FrameNum,2)-round(3*k*sind(gh.data.FhAng{1, FhIdx}(FrameNum,1)));
                if k == 0
                    gh.data.LblMask(xTemp-1:xTemp+1,...
                        yTemp-1:yTemp+1,...
                        FrameNum) = FhIdx;
                else
                    gh.data.LblMask(xTemp,...
                        yTemp,...
                        FrameNum) = FhIdx;
                end
            end
            
        end
        
    catch
        
        fprintf('%s\n',[num2str(batchNum),'_',num2str(FhIdx),'_',num2str(FrameNum)]);
%         gh.param.FailIdx = [gh.param.FailIdx FhIdx];
        break;
        
    end
    
end