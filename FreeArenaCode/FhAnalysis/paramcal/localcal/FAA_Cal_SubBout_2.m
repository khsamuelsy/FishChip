% This script extracts and calculate kinemetric parameters of subsequent
% bouts for all experimental groups
%compare to 1, this script includes new ablated data, all data are pulled

close all
addpath('../data/')

load('../data/cb(pulled2).mat');

global results_cb data data2

currDir=pwd;
cd('../../Programs/Stage 4b - Analyze/main_analyzescript/caltool/')
FAA_loadborder;

DataSet = [10,20,40,30];

all_latency=[]; all_dis=[];
all_boutn=[]; all_freq=[];
all_dori=[]; all_dori2=[];
all_dorin=[]; all_ddisp =[];
all_ddisp_vel =[]; all_dur=[];
all_overall_dori=[];

for p=1:size(DataSet,2)
    CurrentDir = pwd;
    CurrentDir = [CurrentDir(1:end-54),'Data\pulled_2\'];
    display(['Processing DataSet ...',num2str(DataSet(p))]);
    if DataSet(p)==10
        CurrentDir = [CurrentDir,'Intact water'];
        load('Intact water.mat')
    elseif DataSet(p)==20
        CurrentDir = [CurrentDir,'Intact cadaverine'];
        load('Intact cadaverine.mat')
    elseif floor(DataSet(p)/10) == 3
        CurrentDir = [CurrentDir,'L-aba cadaverine'];
        load('L-aba cadaverine_new.mat')  
    elseif floor(DataSet(p)/10) == 4
        CurrentDir = [CurrentDir,'R-aba cadaverine'];
        load('R-aba cadaverine_new.mat')
    elseif floor(DataSet(p)/10) == 5
        CurrentDir = [CurrentDir,'Bi-aba cadaverine'];
        load('Bi-aba cadaverine_new.mat')
    end
    folder_details = dir(CurrentDir);
    DataSet_names = [];
    DataSet2_names = [];
    for i=1:size(folder_details,1)
        if contains(folder_details(i).name,'QCed')
            DataSet_names = [DataSet_names; folder_details(i).name];
        elseif contains(folder_details(i).name,'filtered')
            DataSet2_names = [DataSet2_names; folder_details(i).name];
        end
    end
    

    data.nfiles=size(DataSet_names,1);
    data.FhCoor = [];
    data.FhAng = [];
    data.noffish = 0;
    
    data2.nfiles=size(DataSet_names,1);
    data2.FhCoor = [];
    data2.FhAng = [];
    data2.noffish = 0;

    ori_dir = cd;
    cd (CurrentDir);
    
    for i=1:data.nfiles
        load(DataSet_names(i,:));
        fileb=[DataSet_names(i,1:end-9),'.mat'];
        load(fileb);
        data.FhCoor=[data.FhCoor,FhData_QCed.FhCoor];
        data.FhAng=[data.FhAng,FhData_QCed.FhAng];
        
        fishn(i)=size(FhData_QCed.FhCoor,2);
        tformVec{i}=FhData.tformVec;
        tformMtx{i}=FhData.tformMtx;
        fishsource((data.noffish+1):(size(FhData_QCed.FhCoor,2)+(data.noffish+1)))=i;
        data.noffish=data.noffish+size(FhData_QCed.FhCoor,2);
        clearvars FhData_QCed
    end
    
    for i=1:data2.nfiles
        load(DataSet2_names(i,:));
        data2.FhCoor=[data2.FhCoor,FhData_filtered.FhCoor];
        data2.FhAng=[data2.FhAng,FhData_filtered.FhAng];
        data2.noffish=data2.noffish+size(FhData_filtered.FhCoor,2);
        clearvars FhData_filitered
    end
    
    data.filenames=DataSet_names;
    data2.filenames=DataSet2_names;
    cd (ori_dir); 
    
    
    for m = 1:size(results_cb,2)
        if results_cb{1,m}.datasetno==DataSet(p)      
            indx = m;    
        end 
    end
    
    eventno_count=0;
    latency=[];     dis=[];
    dur=[];    boutn = [];
    freq = [];    dori = [];
    dori2 = [];    dorin =[];
    ddisp =[];    ddisp_vel = [];
    count(p)=0;    overall_dori = [];
    
    for i=1:size(results.bordercrossing_details,2)
        xCoor=[];
        yCoor=[];
        for j=1:288
                xCoor = [xCoor;data.FhCoor{j,i}(:,2)];
                yCoor = [yCoor;data.FhCoor{j,i}(:,1)];
        end
        CoorTform=tformMtx{fishsource(i)}*[yCoor';xCoor']-repmat(tformVec{fishsource(i)},1,size(xCoor,1));
        CoorTform=round(CoorTform);
        for j=1:length(CoorTform(2,:))
            
            if CoorTform(2,j) >=600 || CoorTform(2,j)<=0 || CoorTform(1,j) >=300 || CoorTform(1,j) <=0
    
                CoorTform(1:2,j)=nan;
            end
        end
        CoorTform=[1 0;0 -1]*CoorTform+[0;600];
        count_extraswim = 0;
        for j=1:size(results.bordercrossing_details{1,i},1)
            cum_dis=0;
            cum_boutn=0;
            cum_dori=0;
            
            if ~isempty(results_cb{indx}.dnormal_time{1,eventno_count+j})
                count(p)=count(p)+1;
                starttime=results.bordercrossing_details{1,i}(j,2);
                starttime_2=results.bordercrossing_details{1,i}(j,3);
                finishtime=results.bordercrossing_details{1,i}(j,3); % cell=3 for time/ distance /freq; % cell=4 for others
                finishzone=results.bordercrossing_details{1,i}(j,6); %originally is 6
                flag=0;
                
                for k=finishtime+1:1728000
                    if FAA_zoneid(CoorTform(1,k-1),CoorTform(2,k-1))<finishzone
                        if k==finishtime+1
                            boutn = [boutn;0];
                        end
                        break
                    end
                    if flag==1
                        add_dis=pdist([CoorTform(1,k),CoorTform(2,k);savey,savex]);
                    else
                        add_dis=pdist([CoorTform(1,k),CoorTform(2,k);CoorTform(1,k-1),CoorTform(2,k-1)]);
                    end
                    if ~isnan(add_dis)
                        cum_dis=cum_dis+add_dis;
                    else
                        savey=CoorTform(1,k);
                        savex=CoorTform(2,k);
                        flag=1;
                    end
                    if ~isempty(find(results.allswimbout_details{1,i}(:,2)==k))
                        indx_entry = find(results.allswimbout_details{1,i}(:,2)==k);
                        cum_boutn=cum_boutn+1;
                        start_frame = results.allswimbout_details{1,i}(indx_entry,2);
                        start_frame_pre = results.allswimbout_details{1,i}(indx_entry-1,2);
                        if results.allswimbout_details{1,i}(indx_entry,1) == 0
                            end_frame = results.allswimbout_details{1,i}(indx_entry,3);
                        else
                            end_frame = results.allswimbout_details{1,i}(indx_entry,4);
                        end
                        if results.allswimbout_details{1,i}(indx_entry-1,1) == 0
                            end_frame_pre = results.allswimbout_details{1,i}(indx_entry-1,3);
                        else
                            end_frame_pre = results.allswimbout_details{1,i}(indx_entry-1,4);
                        end
                        delta_angle = abs(FAA_dang_wdir(data2.FhAng{1,i}(start_frame),data2.FhAng{1,i}(end_frame)));
                        delta_angle2 = (FAA_dang_wdir(data2.FhAng{1,i}(start_frame),data2.FhAng{1,i}(end_frame)));
                        delta_angle3 = (FAA_dang_wdir(data2.FhAng{1,i}(start_frame_pre),data2.FhAng{1,i}(end_frame_pre)));
                        dori = [dori ; delta_angle];
                        dori2 = [dori2 ; delta_angle2];
%                         dorin = [dorin ; cum_boutn, delta_angle]; % angle
                        tempdisp = pdist([data2.FhCoor{1,i}(start_frame,1),data2.FhCoor{1,i}(start_frame,2);...
                        data2.FhCoor{1,i}(end_frame,1),data2.FhCoor{1,i}(end_frame,2)])./10;
                        dur = [ dur; (end_frame-start_frame)];
                        ddisp = [ddisp;  tempdisp];
                        ddisp_vel = [ddisp_vel;  (tempdisp./(end_frame-start_frame)).*(240./1000)];
%                         dorin = [dorin ; cum_boutn, delta_angle.*(240/1000)./(end_frame-start_frame)]; % angle velocity 
                        dorin = [dorin ; cum_boutn, (1000/240)*(end_frame-start_frame)]; % duration in ms
                        cum_dori = cum_dori + delta_angle;
                    end

                    if FAA_zoneid(CoorTform(1,k),CoorTform(2,k))<finishzone
                        latency=[latency; (k-finishtime)/240]; %latency in second
                        dis=[dis; cum_dis/10];
                        boutn = [boutn;cum_boutn];
                        
                        freq = [freq; (cum_boutn+1)./((k-starttime_2).*(1000/240))];
                        overall_dori = [overall_dori; cum_dori]; 
                    end
                end
            end
        end
        eventno_count=eventno_count+size(results.bordercrossing_details{1,i},1);
        display(['Dataset: ' num2str(p),': ',num2str(i),'/',num2str(size(results.bordercrossing_details,2))]);

    end
    latency(end+1:10000)=NaN;
    latency=reshape(latency,10000,1);
    dis(end+1:10000)=NaN;     dis=reshape(dis,10000,1);
    boutn(end+1:10000)=NaN;    boutn=reshape(boutn,10000,1);
    dori(end+1:10000)=NaN;    dori=reshape(dori,10000,1);
    dori2(end+1:10000)=NaN;    dori2=reshape(dori2,10000,1);
    dur(end+1:10000)=NaN;    dur=reshape(dur,10000,1);
    dorin(end+1:10000,:)=NaN;    ddisp(end+1:10000)=NaN;
    ddisp=reshape(ddisp,10000,1);    ddisp_vel(end+1:10000)=NaN;
    ddisp_vel=reshape(ddisp_vel,10000,1);    overall_dori(end+1:10000)=NaN;
    overall_dori=reshape(overall_dori,10000,1);    freq(end+1:10000)=NaN;
    freq=reshape(freq,10000,1);
    all_latency=[all_latency, latency];    all_dis=[all_dis,dis];
    all_boutn=[all_boutn,boutn];    all_dori=[all_dori,dori];
    all_dori2=[all_dori2,dori2];    all_dorin=[all_dorin,dorin];
    all_ddisp=[all_ddisp,ddisp];    all_ddisp_vel=[all_ddisp_vel,ddisp_vel];
    all_dur = [all_dur,dur];    all_overall_dori=[all_overall_dori,overall_dori];
    all_freq=[all_freq,freq];
end
close all
cd(currDir)
cal.all_latency = all_latency;
cal.all_dis = all_dis;
cal.all_freq = all_freq*1000; %bout no in second (Hz)
