function fhtrack_getcentroid_first(batchNum)

global gh

NumFrame = size(gh.data.ImRaw, 3);
FhCoorSze = input('Number of fish in arena?')

% gh.data.FhCentroid = cell(NumFrame,1);
% gh.data.SepFlag = zeros(NumFrame,1,'logical');
% gh.data.MergeFlag = zeros(NumFrame,1,'logical');

for k = 1:2
%     if mod(k,100) == 0
%         set(gh.disp.textTrackProgress,'String', ['Found centroids: ' num2str(k) '/' num2str(NumFrame) ' images']);
%         pause(0.0001);
%     end
     [gh.data.FhCentroid{k,1}, gh.data.FhOrient{k,1}]...
         = fhtrack_fhsegment(gh.data.ImRaw(:,:,k));

    if k >= 2
        gh.data.MergeFlag(k,1) = (size(gh.data.FhCentroid{k,1},1) < size(gh.data.FhCentroid{k-1,1},1));
        gh.data.SepFlag(k,1) = (size(gh.data.FhCentroid{k,1},1) > size(gh.data.FhCentroid{k-1,1},1));
    end
end
gh.data.RepIdx = zeros(1,size(gh.data.FhCentroid{1,1},1),'logical');
% if batchNum == 1
%     gh.data.RepIdx = zeros(1,size(gh.data.FhCentroid{1,1},1),'logical');
%     StartFrame = 2;
% else
%     StartFrame = 1;
% end

% for k = 1:2
%     if k == 1
%         OrderIdx = fhtrack_findmindistcent(gh.data.FhCoorTemp, gh.data.FhCentroid{k,1}, gh.data.RepIdx, gh.data.SepFlag(k,1));
%     else
%         OrderIdx = fhtrack_findmindistcent(gh.data.FhCentroid{k-1,1}, gh.data.FhCentroid{k,1}, gh.data.RepIdx, gh.data.SepFlag(k,1));
%     end
%     gh.data.FhCentroid{k,1} = fhtrack_sortCentroid(gh.data.FhCentroid{k,1}, OrderIdx);
%     gh.data.FhOrient{k,1} = fhtrack_sortCentroid(gh.data.FhOrient{k,1}, OrderIdx);
%     gh.data.RepIdx = fhtrack_checkrepeat(gh.data.FhCentroid{k,1});
% end



gh.data.FhCoor = cell(1, FhCoorSze);
gh.data.FhAng = cell(1, FhCoorSze);

for k = 1:FhCoorSze
    gh.data.FhCoor{1,k} = zeros(NumFrame,2);
    gh.data.FhAng{1,k} = zeros(NumFrame,1);
    for h=1:2
        gh.data.FhCoor{1,k}(h,:) = round(gh.data.FhCentroid{h,1}(k,:));
        gh.data.FhAng{1,k}(h,1) = round(gh.data.FhOrient{h,1}(k,1)/10)*10;
        gh.data.FhCoor{1,k}(h,:) = round(gh.data.FhCoor{1,k}(h,:)+...
             [3*cosd(gh.data.FhAng{1,k}(h,1)),...
                3*sind(gh.data.FhAng{1,k}(h,1))]);
    end
  
    
%     if (abs(gh.data.FhAng{1,k}(1,1)-gh.output.FhAng{end,k}(end,1))>=160) && (abs(gh.data.FhAng{1,k}(1,1)-gh.output.FhAng{end,k}(end,1))<=200)
%         gh.data.FhCoor{1,k}(1,:)=gh.output.FhCoor{end,k}(end,:);
%         gh.data.FhAng{1,k}(1,1)=gh.output.FhAng{end,k}(end,1);
%     end
%     
%     if (abs(gh.data.FhAng{1,k}(2,1)-gh.data.FhAng{1,k}(1,1))>=160) && (abs(gh.data.FhAng{1,k}(2,1)-gh.data.FhAng{1,k}(1,1))<=180)
%         gh.data.FhCoor{1,k}(2,:)=gh.data.FhCoor{1,k}(1,:);
%         gh.data.FhAng{1,k}(2,1)=gh.data.FhAng{1,k}(1,1);
%     end
%         
%     if distance(gh.output.FhCoor{end,k}(end,:),gh.data.FhCoor{1,k}(1,:))>64 | distance(gh.output.FhCoor{end,k}(end,:),gh.data.FhCoor{1,k}(2,:))>64
%         gh.data.FhCoor{1,k}(1,:)=gh.output.FhCoor{end,k}(end,:);
%         gh.data.FhCoor{1,k}(2,:)=gh.output.FhCoor{end,k}(end,:);
%         gh.data.FhAng{1,k}(1,1)=gh.output.FhAng{end,k}(end,1);
%         gh.data.FhAng{1,k}(2,1)=gh.output.FhAng{end,k}(end,1);
%     end
    
    for h = 3:NumFrame
%         UniqueFlag = fhtrack_isunique(gh.data.FhCentroid{h,1},k);
%         if UniqueFlag && (gh.data.FhCentroid{h,1}(k,1)~=0)
%             gh.data.FhCoor{1,k}(h,:) = round(gh.data.FhCentroid{h,1}(k,:));
%             gh.data.FhAng{1,k}(h,1) = round(gh.data.FhOrient{h,1}(k,1)/10)*10;
%             gh.data.FhCoor{1,k}(h,:) = round(gh.data.FhCoor{1,k}(h,:)+...
%                 [3*cosd(gh.data.FhAng{1,k}(h,1)),...
%                 3*sind(gh.data.FhAng{1,k}(h,1))]);
%         else
            gh.data.FhCoor{1,k}(h,:) = [0 0];
            gh.data.FhAng{1,k}(h,1) = 0;
%         end
    end
    
    
end