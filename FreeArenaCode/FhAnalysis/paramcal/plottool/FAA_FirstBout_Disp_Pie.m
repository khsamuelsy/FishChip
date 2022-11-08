function FAA_FirstBout_Disp_Pie(options)
olddir = pwd;
mycolor = colorplate;
load('../data/cb(pulled2)_PR.mat');
global results_cb plotnum
cd('../');currDir = pwd;
addpath([currDir,'/data']);
path_analysis = [currDir(1:end-8),'\Programs\Stage 4b - Analyze\main_analyzescript\caltool\'];
cd(path_analysis)
DataSet = [10,20,40,30];
all_ddfb = [];

for p=1:4
    %size(DataSet,2)
    %% change directory to updated pooled data directory
    %% and select corresponding subfolder
    delta_dist_from_border =[];
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
    
    data.nfiles=size(DataSet_names,1);    data.FhCoor = [];    data.FhAng = [];
    data.noffish = 0;    ori_dir = cd;    cd (CurrentDir);
    
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
            if ~isempty(results_cb{indx}.dnormal_time{1,eventno_count+j})

                start = (results.bordercrossing_details{1,i}(j,3)-results.bordercrossing_details{1,i}(j,1))/(results.bordercrossing_details{1,i}(j,4)-results.bordercrossing_details{1,i}(j,1));
                
                second_bout_start_time = find(results_cb{indx}.dist_time{1,eventno_count+j}(:,1)==start);
                start_frame = results.bordercrossing_details{1,i}(j,3);
                end_frame = results.bordercrossing_details{1,i}(j,4);

                diff = mean(results_cb{indx}.dist_time{1,eventno_count+j}(end,2)) - results_cb{indx}.dist_time{1,eventno_count+j}(second_bout_start_time,2);
   
                delta_dist_from_border = [delta_dist_from_border; diff/10];

            end
        end
        eventno_count=eventno_count+size(results.bordercrossing_details{1,i},1);
    end

    delta_dist_from_border(end+1:10000)=NaN;
    all_ddfb = [all_ddfb, delta_dist_from_border];
end

temp_4 = all_ddfb(:,4);
temp_4 = temp_4(~isnan(temp_4));
temp_3 = all_ddfb(:,3);
temp_3 = temp_3(~isnan(temp_3));
temp_3n4 = [temp_3;temp_4];
temp_3n4(end+1:10000) = NaN;
plotdata = [all_ddfb(:,1),all_ddfb(:,2),temp_3n4];
disp_thres = 1;
datasize = zeros(3,1);
insize = zeros(3,1);
outsize = zeros(3,1);
for i=1:3
    temp = plotdata(:,i);
    A=zeros(10000,1);
    nantemp = temp(~isnan(temp));
    datasize(i) = length(nantemp);
    insize(i) = sum(nantemp>disp_thres); 
    outsize(i) = sum(nantemp<-disp_thres); 
    middlesize(i) = datasize(i)-insize(i)-outsize(i);
    figure(i)
    p=pie([insize(i),middlesize(i),outsize(i)]);
    colormap([[237 125 49]./255;  ...    %// red
        .7 .7 .7; ...     %// green
        [100 122 154]./255;])  %// grey
    ax.Children(2).EdgeAlpha = 0;  % index 2 and 4 corrosponds to the ptaches in ax.Children . If the order is different in your case change it accordingly
    ax.Children(4).EdgeAlpha = 0;
%     delete(ax.Children([1, 3]))
set(figure(i), 'Units', 'pixels', 'Position', [500*i, 500, 400, 400]);
end
if options.stat
inoutperc = [insize./datasize,outsize./datasize,(datasize-(insize+outsize))./datasize];
cd(currDir);cd(olddir)
ChiSqTestData_x =[];
ChiSqTestData_y =[];
for i=1:3
    ChiSqTestData_x = [ChiSqTestData_x;repmat('y',insize(i),1); repmat('n',datasize(i)-insize(i),1);];
    ChiSqTestData_y =[ChiSqTestData_y;repmat(num2str(i),datasize(i),1);];
end

[tbl, chi2m, pm] = crosstab(ChiSqTestData_x ,ChiSqTestData_y );
MaraTestData = [insize,datasize];
size(MaraTestData)
tmcomptest(MaraTestData,0.01)
end
        
        