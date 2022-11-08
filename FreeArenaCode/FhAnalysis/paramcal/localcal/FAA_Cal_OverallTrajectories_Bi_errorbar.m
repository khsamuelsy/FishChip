function FAA_Cal_OverallTrajectories

%% 1121 ; water%% 1222 : cadaverine%% 30 : L-ablated%% 40 : R-ablated%% 50 : B-ablated
currDir = pwd;
path_zonelocate = [currDir(1:end-18),'Programs\Stage 4b - Analyze\main_analyzescript\'];
DataSet = [1121,1222,40,30,50];
cd(path_zonelocate);FAA_loadborder
global border zone 
close all
for p=1:size(DataSet,2)
    % change directory to updated pooled data directory
    % and select corresponding subfolder
    CurrentDir = pwd;
    CurrentDir = [CurrentDir(1:end-46),'Data\pulled_2\'];
    display(['Processing Pooled DataSet (last updated: 20190428) ...',num2str(DataSet(p))]);
    if DataSet(p)==1121
        CurrentDir = [CurrentDir,'Intact water'];
    elseif DataSet(p)==1222
        CurrentDir = [CurrentDir,'Intact cadaverine'];
    elseif floor(DataSet(p)/10) == 3
        CurrentDir = [CurrentDir,'L-aba cadaverine'];
    elseif floor(DataSet(p)/10) == 4
        CurrentDir = [CurrentDir,'R-aba cadaverine'];
    elseif floor(DataSet(p)/10) == 5
        CurrentDir = [CurrentDir,'Bi-aba cadaverine'];
    end
    %% identify number of datafiles that is QC-ed (quality controlled)
    %% and initialize variables
    folder_details = dir(CurrentDir);
    DataSet_names = [];
    for i=1:size(folder_details,1)
        if contains(folder_details(i).name,'_QCed')
            DataSet_names = [DataSet_names; folder_details(i).name];
        end
    end
 data.nfiles=size(DataSet_names,1);
    %% continuously load in data (FhCoor; FhAng; tformVec; tFormMtx
    for tt=1:data.nfiles
           
    data.FhCoor = [];    data.FhAng = [];
    data.noffish = 0;    ori_dir = cd;    cd (CurrentDir);
        load([DataSet_names(tt,1:end-9),'.mat']);
        load([DataSet_names(tt,1:end-9),'_QCed.mat']);
        data.FhCoor=[data.FhCoor,FhData_QCed.FhCoor];  data.FhAng=[data.FhAng,FhData_QCed.FhAng];
        tformVec=FhData.tformVec;     tformMtx=FhData.tformMtx;
        fishsource((data.noffish+1):(size(FhData_QCed.FhCoor,2)+(data.noffish)))=i;
        data.noffish=data.noffish+size(FhData_QCed.FhCoor,2);
        clearvars FhData_QCed FhData
        
        data.filenames=DataSet_names;    cd (ori_dir);    Im_Px_count=zeros(300,600);
        for i=1:data.noffish
            flag=zeros(300,600);
            xCoor=[];        yCoor=[];
            for j=1:288
                xCoor = [xCoor;data.FhCoor{j,i}(:,2)];
                yCoor = [yCoor;data.FhCoor{j,i}(:,1)];
            end
   
            CoorTform=tformMtx*([yCoor';xCoor']-repmat(tformVec,1,size(xCoor,1)));
            CoorTform=round(CoorTform);
            for j=1:length(CoorTform(2,:))
                if CoorTform(2,j) >=600 || CoorTform(2,j)<=0 || CoorTform(1,j) >=300 || CoorTform(1,j) <=0
                    CoorTform(1:2,j)=nan;
                end
            end
            CoorTform=[1 0;0 -1]*CoorTform+[0;600];
            for j=1:length(CoorTform(2,:))
                if sum(isnan([CoorTform(1,j),CoorTform(2,j)]))==0
%                     && flag(CoorTform(1,j),CoorTform(2,j))==0
                    flag(CoorTform(1,j),CoorTform(2,j))=1;
                    
                    Im_Px_count(CoorTform(1,j),CoorTform(2,j))=Im_Px_count(CoorTform(1,j),CoorTform(2,j))+1;
                end
            end
            display(['Processing Fish : ', num2str(i), '  (Total Fish No.: ',num2str(data.noffish),')']);
        end
        Im_Px= Im_Px_count/sum(sum(Im_Px_count));
        cal.Im_Px{p,tt} = Im_Px;
        cal.fishn{p,tt} = data.noffish;
        
        
        
        
    end

end
cd(currDir);
save('OverallTrajectories_Bi.mat','cal');

end
