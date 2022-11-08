function FhAnalysis_filter(fliplr_flag)

global gh

[gh.file,gh.path] = uigetfile('*.mat');

load(fullfile(gh.path,gh.file));
load(fullfile(gh.path,[gh.file(1:end-9),'.mat']));


gh.da.fhdata.source=fullfile(gh.path,gh.file);

gh.da.fhdata.FhCoor=FhData_QCed.FhCoor;
gh.da.fhdata.FhAng=FhData_QCed.FhAng;
gh.da.param.noffish=size(gh.da.fhdata.FhCoor,2);
gh.da.param.tformMtx=FhData.tformMtx;
gh.da.param.refcoor=FhData.refcoor;

side_margin = 40;
meet_margin = 40;
BW_roi=zeros(300,600,'logical');
BW_roi(side_margin+1:end-side_margin,side_margin+1:end-side_margin)=1;
gh.da.zone.BW_roi=BW_roi;


for i=1:gh.da.param.noffish
    for j=1:288

        for k=1:6000
            if gh.da.fhdata.FhCoor{j,i}(k,1)==0 | gh.da.fhdata.FhCoor{j,i}(k,2)==0 
                gh.da.fhdata.FhCoor{j,i}(k,1)=NaN;
                gh.da.fhdata.FhCoor{j,i}(k,2)=NaN;
                gh.da.fhdata.FhAng{j,i}(k)=NaN;
            end
            if gh.da.fhdata.FhAng{j,i}(k)==360
                gh.da.fhdata.FhAng{j,i}(k)=0;
            end
        end
    end
    display(['Filtered FhData of fish n : ',num2str(i),' ',gh.file]);
end


for i=1:gh.da.param.noffish
    for j=1:288
        gh.da.fhdata.FhCoor{j,i}=gh.da.fhdata.FhCoor{j,i} - repmat(gh.da.param.refcoor{1,1},6000,1);
        if fliplr_flag
            gh.da.fhdata.FhCoor{j,i}=[1 0;0 -1]*round(gh.da.param.tformMtx*gh.da.fhdata.FhCoor{j,i}')+[0;600];
        else
            gh.da.fhdata.FhCoor{j,i}=round(gh.da.param.tformMtx*gh.da.fhdata.FhCoor{j,i}');
        end
        gh.da.fhdata.FhCoor{j,i}=gh.da.fhdata.FhCoor{j,i}';
        if fliplr_flag
            gh.da.fhdata.FhAng{j,i}=360-gh.da.fhdata.FhAng{j,i};
        end
    end
end

for i=1:gh.da.param.noffish
    gh.da.fhdata.FishCoor{1,i}=[];
    gh.da.fhdata.FishAng{1,i}=[];
    for j=1:288
        gh.da.fhdata.FishCoor{1,i}=[gh.da.fhdata.FishCoor{1,i};gh.da.fhdata.FhCoor{j,i}];
        gh.da.fhdata.FishAng{1,i}=[gh.da.fhdata.FishAng{1,i};gh.da.fhdata.FhAng{j,i}];
    end
end

gh.da.fhdata.FhCoor={};
gh.da.fhdata.FhCoor=gh.da.fhdata.FishCoor;
gh.da.fhdata.FishCoor={};
gh.da.fhdata.FhAng={};
gh.da.fhdata.FhAng=gh.da.fhdata.FishAng;
gh.da.fhdata.FishAng={};
