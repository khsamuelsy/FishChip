function plotdata = FAA_Cal_FirstBout_AngleChangebyFrame_1(nframe)
olddir = pwd;

labels={'','Control','Intact','L-aba','R-aba','Bi-aba',''};
load('../data/cb(pulled2)_PR_Bi_Mirror.mat');
minboutlength = 100;
maxboutlength = 0;
%% 10 ; water
%% 20 : cadaverine
%% 30 : L-ablated
%% 40 : R-ablated
%% 50 : B-ablated
global results_cb_wclass plotnum

results_cb_wclass=results_cb;

cd('../')
addpath([pwd,'\data\'])
currDir = pwd;
path_zonelocate = [currDir(1:end-8),'\Programs\Stage 4b - Analyze\main_analyzescript\'];
cd(path_zonelocate)

DataSet = [10,20,40,30,50];

all_deltad = [];

for p=1:size(DataSet,2)
    
    %% change directory to updated pooled data directory
    %% and select corresponding subfolder
    delta_dist_from_border =[];
    deltad = [];
    disfromborder = [];
    deltad_vel = [];
    CurrentDir = pwd;
    CurrentDir = [CurrentDir(1:end-46),'Data\pulled_2\'];
    display(['Processing Pooled DataSet (last updated: 20190428) ...',num2str(DataSet(p))]);
    
    if DataSet(p)==10
        CurrentDir = [CurrentDir,'Intact water'];
        load('PR_Intact_Water.mat')
    elseif DataSet(p)==20
        CurrentDir = [CurrentDir,'Intact cadaverine'];
        load('PR_Intact_Cadaverine.mat')
    elseif floor(DataSet(p)/10) == 3
        CurrentDir = [CurrentDir,'L-aba cadaverine'];
        load('PR_L-aba_Cadaverine.mat')
    elseif floor(DataSet(p)/10) == 4
        CurrentDir = [CurrentDir,'R-aba cadaverine'];
        load('PR_R-aba_Cadaverine.mat')
        
    elseif floor(DataSet(p)/10) == 5
        CurrentDir = [CurrentDir,'Bi-aba cadaverine'];
        load('PR_Bi-aba_Cadaverine.mat')
    end
    %% identify number of datafiles that is QC-ed (quality controlled)
    %% and initialize variables
    folder_details = dir(CurrentDir);
    DataSet_names = [];
    
    for i=1:size(folder_details,1)
        if contains(folder_details(i).name,'filtered')
            DataSet_names = [DataSet_names; folder_details(i).name];
        end
    end
    
    data.nfiles=size(DataSet_names,1);
    data.FhCoor = [];
    data.FhAng = [];
    data.noffish = 0;
    ori_dir = cd;
    
    cd (CurrentDir);
    
    for i=1:data.nfiles
        load(DataSet_names(i,:));
        data.FhCoor=[data.FhCoor,FhData_filtered.FhCoor];
        data.FhAng=[data.FhAng,FhData_filtered.FhAng];
        data.noffish=data.noffish+size(FhData_filtered.FhCoor,2);
        clearvars FhData_filtered
    end
    
    data.filenames=DataSet_names;
    cd (ori_dir);
    
    
    for m = 1:size(results_cb,2)
        if results_cb{1,m}.datasetno==DataSet(p)
            indx = m;
        end
    end
    eventno_count=0;
    for i=1:size(results.bordercrossing_details,2)
        
        for j=1:size(results.bordercrossing_details{1,i},1)
            
            if isempty(results_cb_wclass{indx}.dnormal_time{1,eventno_count+j})
                results_cb_wclass{indx}.class(eventno_count+j)=0;
            else
                start_frame = results.bordercrossing_details{1,i}(j,3);
                end_frame = results.bordercrossing_details{1,i}(j,4);
                if end_frame-start_frame<minboutlength
                    minboutlength = end_frame-start_frame;
                end
                if end_frame-start_frame>maxboutlength
                    maxboutlength = end_frame-start_frame;
                end
                
                if ~isnan(end_frame)

                    deltad = [deltad;abs(FAA_dang_wdir(data.FhAng{1,i}(start_frame),data.FhAng{1,i}(start_frame+nframe)))];

                 
                end
                %                 end
                
            end
        end
        eventno_count=eventno_count+size(results.bordercrossing_details{1,i},1);
    end
    
    deltad(end+1:10000,:)=NaN;
    all_deltad = [all_deltad,deltad];

end
plotdata = all_deltad(:,1:5);
cd(olddir)
end


