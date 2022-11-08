function FAA_FirstBout

% this script plots the total orientation change of first bout
% specify the flag for parametric?
% options.parametric = false
% 10 ; water
% 20 : cadaverine
% 30 : L-ablated
% 40 : R-ablated

olddir = pwd;

close all


load('../data/cb(pulled2)_PR.mat');

cd('../')
addpath([pwd,'\data\'])
currDir = pwd;
path_caltool = [currDir(1:end-8),'\Programs\Stage 4b - Analyze\main_analyzescript\caltool\'];

cd(path_caltool)
% DataSet = [10,20,30,40,50];
DataSet = [10,20,40,30];
all_ddfb = [];
all_deltad = [];
all_deltad2 = [];
all_delta_disp = [];
all_delta_dist = [];
all_deltad_vel = [];
all_delta_disp_vel = [];
all_deltad_dur = [];
all_latency = [];
all_in_angle=[];
    zone_2=24;
    zone_1=20;
for p=1:size(DataSet,2)
    
    %% change directory to updated pooled data directory
    %% and select corresponding subfolder
    delta_dist_from_border =[];
    deltad = [];
    deltad2 = [];
    delta_disp = [];
    delta_disp_vel = [];
    delta_dist = [];
    deltad_vel = [];
    deltad_dur = [];
    latency = [];
    in_angle=[];
    CurrentDir = pwd;
    CurrentDir = [CurrentDir(1:end-54),'Data\pulled_2\'];
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

            if (results.bordercrossing_details{1,i}(j,5)<zone_2 && ...
                    results.bordercrossing_details{1,i}(j,5)>zone_1 && ...
                    ~isnan(results.bordercrossing_details{1,i}(j,4))) && ...
                             ~isempty(results_cb{indx}.dnormal_time{1,eventno_count+j})
                
  

                start_frame = results.bordercrossing_details{1,i}(j,3);
                end_frame = results.bordercrossing_details{1,i}(j,4);
                rest_dis_from_border = FAA_ptcurvedist_samezone(data.FhCoor{1,i}(start_frame,1),data.FhCoor{1,i}(start_frame,2),i,j,results);
                delta_dist_from_border = [delta_dist_from_border; results.bordercrossing_details{1,i}(j,10)];
                
                dist_sum = 0;
                for zz = start_frame+1:end_frame
                    
                    dist_sum=dist_sum+pdist([data.FhCoor{1,i}(zz-1,1),data.FhCoor{1,i}(zz-1,2);...
                        data.FhCoor{1,i}(zz,1),data.FhCoor{1,i}(zz,2)]);
                end
                
                if ~isnan(end_frame)
                    deltad = [deltad;abs(FAA_dang_wdir(data.FhAng{1,i}(start_frame),data.FhAng{1,i}(end_frame)))];
                    deltad2 = [deltad2;(FAA_dang_wdir(data.FhAng{1,i}(start_frame),data.FhAng{1,i}(end_frame)))];
                    
                    delta_disp = [delta_disp;pdist([data.FhCoor{1,i}(start_frame,1),data.FhCoor{1,i}(start_frame,2);...
                        data.FhCoor{1,i}(end_frame,1),data.FhCoor{1,i}(end_frame,2)])];
                    delta_disp_vel = [delta_disp_vel;pdist([data.FhCoor{1,i}(start_frame,1),data.FhCoor{1,i}(start_frame,2);...
                        data.FhCoor{1,i}(end_frame,1),data.FhCoor{1,i}(end_frame,2)])./(end_frame-start_frame)];
                    delta_dist = [delta_disp;dist_sum];
                    deltad_vel = [deltad_vel;(abs(FAA_dang_wdir(data.FhAng{1,i}(start_frame),data.FhAng{1,i}(end_frame)))/(end_frame-start_frame))];
                    deltad_dur = [deltad_dur;(end_frame-start_frame).*1000/240];
                    latency = [latency;results.bordercrossing_details{1,i}(j,3)-results.bordercrossing_details{1,i}(j,2);];
                    in_angle = [in_angle;results.bordercrossing_details{1,i}(j,9)];
                end
            end
        end
        eventno_count=eventno_count+size(results.bordercrossing_details{1,i},1);
    end
    
    
    delta_dist_from_border(end+1:10000,:)=NaN;
    deltad(end+1:10000,:)=NaN;
    deltad2(end+1:10000,:)=NaN;
    delta_disp(end+1:10000,:)=NaN;
    delta_disp_vel(end+1:10000,:)=NaN;
    delta_dist(end+1:10000,:)=NaN;
    deltad_vel(end+1:10000,:)=NaN;
    deltad_dur(end+1:10000,:)=NaN;
    latency(end+1:10000,:)=NaN;
    in_angle(end+1:10000,:)=NaN;
    all_ddfb = [all_ddfb, abs(delta_dist_from_border)];
    all_deltad = [all_deltad,deltad];
    all_deltad2 = [all_deltad2,deltad2];
    all_delta_disp = [all_delta_disp,delta_disp];
    all_delta_disp_vel = [all_delta_disp_vel,delta_disp_vel];
    all_delta_dist= [all_delta_disp,delta_dist];
    all_deltad_vel = [all_deltad_vel,deltad_vel];
    all_deltad_dur = [all_deltad_dur,deltad_dur];
    all_in_angle = [all_in_angle,in_angle];
    all_latency = [all_latency,latency];
end
% unified for the physical units to S.I. units
all_deltad_vel=all_deltad_vel.*240./1000;
all_deltad_vel(all_deltad_vel>3) = 3;
all_delta_disp = all_delta_disp./10;
all_delta_dist = all_delta_dist./10;
all_delta_disp_vel = all_delta_disp_vel.*240./1000./10;
cal.all_deltad = all_deltad;
cal.all_deltad2 = all_deltad2;
cal.all_delta_disp = all_delta_disp;
cal.all_delta_disp_vel = all_delta_disp_vel;
cal.all_delta_dist = all_delta_dist;
cal.all_deltad_vel = all_deltad_vel;
cal.all_deltad_dur = all_deltad_dur;
cal.all_in_angle = all_in_angle;
cal.all_latency = all_latency;
cd(olddir)
save('FirstBout_PR.mat','cal');
end


