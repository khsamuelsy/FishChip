function FhAnalysis_filtermeetingevent
% this script filter fish-touching each other / walls
global gh
count=0;
meet_margin = 40;
for i=1:gh.da.param.noffish
    
    for j=1:1728000
        
        % filter those due to transform
        if gh.da.fhdata.FhCoor{1,i}(j,1)>300 | gh.da.fhdata.FhCoor{1,i}(j,1) <= 0 ...
                | gh.da.fhdata.FhCoor{1,i}(j,2)>600 | gh.da.fhdata.FhCoor{1,i}(j,2) <= 0
            gh.da.fhdata.FhCoor{1,i}(j,:)=[NaN NaN];
            gh.da.fhdata.FhAng{1,i}(j)=NaN;
        end
        
        % 
        if ~isnan(gh.da.fhdata.FhCoor{1,i}(j,1))
            if ~gh.da.zone.BW_roi(gh.da.fhdata.FhCoor{1,i}(j,1),gh.da.fhdata.FhCoor{1,i}(j,2))
                gh.da.fhdata.FhCoor{1,i}(j,:)=[NaN NaN];
                gh.da.fhdata.FhAng{1,i}(j)=NaN;
            end
        end
        
        
        for k=1:gh.da.param.noffish
            if k~=i & pdist([gh.da.fhdata.FhCoor{1,i}(j,1),gh.da.fhdata.FhCoor{1,i}(j,2); ...
                    gh.da.fhdata.FhCoor{1,k}(j,1),gh.da.fhdata.FhCoor{1,k}(j,2)]) <= meet_margin
                gh.da.fhdata.FhCoor{1,i}(j,:)=[NaN NaN];
                gh.da.fhdata.FhAng{1,i}(j)=NaN;
                break
            end
            if k~=i & isnan(gh.da.fhdata.FhCoor{1,k}(j,1))
                m=find(~isnan(gh.da.fhdata.FhCoor{1,k}(1:j,1)));
                if size(m,1)~=0 ...
                        &pdist([gh.da.fhdata.FhCoor{1,i}(j,1),gh.da.fhdata.FhCoor{1,i}(j,2); ...
                        gh.da.fhdata.FhCoor{1,k}(m(end),1),gh.da.fhdata.FhCoor{1,k}(m(end),2)]) <= meet_margin
                    gh.da.fhdata.FhCoor{1,i}(j,:)=[NaN NaN];
                    gh.da.fhdata.FhAng{1,i}(j)=NaN;
                    break
                end
            end
        end
        
        if mod(j,1728) == 0
            display(['Filtered FhData fish n: ',num2str(i),' *** ',num2str(j*100/1728000),'%  ',gh.file])
        end
        
    end
end


gh.output.FhCoor = gh.da.fhdata.FhCoor;
gh.output.FhAng = gh.da.fhdata.FhAng;
FhData_filtered = gh.output;

save(fullfile(gh.path,[gh.file(1:end-9),'_filtered.mat']),'FhData_filtered');


