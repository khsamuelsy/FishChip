function FAA_FirstBout_Disp_Bi(options)

olddir = pwd;
mycolor = colorplate;
load('../data/cb(pulled2)_PR_Bi_Mirror.mat');
global results_cb
cd('../');currDir = pwd;
addpath([currDir,'/data']);
path_analysis = [currDir(1:end-8),'\Programs\Stage 4b - Analyze\main_analyzescript\caltool\'];
cd(path_analysis)
DataSet = [10,20,40,30,50];all_ddfb = [];

for p=1:5
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
    data.FhCoor = [];    data.FhAng = [];
    data.noffish = 0;    ori_dir = cd;
    cd (CurrentDir);
    
    for i=1:data.nfiles
        load(DataSet_names(i,:));
        data.FhCoor=[data.FhCoor,FhData_filtered.FhCoor];
        data.FhAng=[data.FhAng,FhData_filtered.FhAng];
        data.noffish=data.noffish+size(FhData_filtered.FhCoor,2);
        clearvars FhData_filtered
    end
    
    data.filenames=DataSet_names;    cd (ori_dir);
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
%                 second_bout_start_time = find(results_cb{indx}.dist_time{1,eventno_count+j}(:,1)==start);
                start_frame = results.bordercrossing_details{1,i}(j,3);
                end_frame = results.bordercrossing_details{1,i}(j,4);
                
                
%                 diff = results_cb{indx}.dist_time{1,eventno_count+j}(end,2) ...
%                     - results_cb{indx}.dist_time{1,eventno_count+j}(second_bout_start_time,2); % new one
        
                rest_dis_from_border = FAA_ptcurvedist_samezone(data.FhCoor{1,i}(start_frame,1),data.FhCoor{1,i}(start_frame,2),i,j,results);
                firstboutend_dis_from_border = FAA_ptcurvedist_samezone(data.FhCoor{1,i}(end_frame,1),data.FhCoor{1,i}(end_frame,2),i,j,results);
                diff = firstboutend_dis_from_border-rest_dis_from_border;
                delta_dist_from_border = [delta_dist_from_border; diff/10];
            end
        end
        eventno_count=eventno_count+size(results.bordercrossing_details{1,i},1);
    end
    delta_dist_from_border(end+1:10000)=NaN;
    all_ddfb = [all_ddfb, delta_dist_from_border];
end


cd(olddir)
param = [all_ddfb(:,1),all_ddfb(:,2),all_ddfb(:,3),all_ddfb(:,4),all_ddfb(:,5)];
tempmid = zeros(1,4);
figure(1);hold on
for i=1:5
    temp = param(:,i);
    A=zeros(10000,1);
    for j=1:10000
        sz = 3;
        if i == 1 || i ==2
            cen_x = i;
        elseif i == 3
            cen_x = 2.95;
        elseif i == 4
            cen_x = 3.05;
                    elseif i == 5
            cen_x = 4;
        end
        data_perc=sum(round(temp)==round(temp(j)));
        weight=data_perc/sum(~isnan(temp));
        if i == 3
            therandn = abs(rand-0.5)*-1;
        elseif i == 4
            therandn = abs(rand-0.5);
        else
            therandn = (rand-0.5);
        end
        A(j)=cen_x+(therandn)*(sz*weight)/2;
    end
    Y = prctile(temp,[25 75]);
    for j=1:size(temp)
        if abs(temp(j))<1
            scatter(A(j),temp(j),'o','MarkerEdgeColor',[.7 .7 .7])
        end
    end
    scatter(A(temp>=1),temp(temp>=1),'MarkerEdgeColor',[237 125 49]./255)
    scatter(A(temp<=-1),temp(temp<=-1),'MarkerEdgeColor',[100 122 154]./255)
    if i==1 || i==5
        color_draw=mycolor.baseline;
    elseif i==2
        color_draw=mycolor.mainbi;
    elseif i==3
        color_draw=mycolor.mainleft;
    elseif i==4
        color_draw = mycolor.mainright;
    end
    
    len_1 = .12;    len_2 = .08;
    xlim2 = 3.2;    xlim1 = 0.5;
    
    tempmid(i) = nanmedian(temp);
    if i==3
        plot([cen_x-len_1,cen_x],[tempmid(i) tempmid(i)],'Color',color_draw,'LineWidth',2)
        plot([cen_x-len_2,cen_x],[Y(1) Y(1)],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x-len_2,cen_x],[Y(2) Y(2)],'Color',color_draw,'LineWidth',1.5)
    elseif i==4
        plot([cen_x,cen_x+len_1],[tempmid(i) tempmid(i)],'Color',color_draw,'LineWidth',2)
        plot([cen_x,cen_x+len_2],[Y(1) Y(1)],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x,cen_x+len_2],[Y(2) Y(2)],'Color',color_draw,'LineWidth',1.5)
    else
        plot([cen_x-len_1,cen_x+len_1],[tempmid(i) tempmid(i)],'Color',color_draw,'LineWidth',2)
        plot([cen_x-len_2,cen_x+len_2],[Y(1) Y(1)],'Color',color_draw,'LineWidth',1.5)
        plot([cen_x-len_2,cen_x+len_2],[Y(2) Y(2)],'Color',color_draw,'LineWidth',1.5)
    end
    hold on;    box off
end
plot([xlim1 xlim2],[1 1],':','color',[237 125 49]./255)
plot([xlim1 xlim2],[-1 -1],':','color',[100 122 154]./255)
set(gca,'XTickLabel',[]);
xticks([]);
set(figure(1), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
ax1 = gca;
f2 = figure(2);
ax2 = copyobj(ax1,f2);
set(figure(2), 'Units', 'pixels', 'Position', [1000, 500, 400, 400]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
set(gca,'XTick',[]);
ax2.XAxisLocation = 'origin';

if options.stat
    stat_param = [param(:,1:2);nan(10000,2)];
    stat_param(:,3) = [param(:,3);param(:,4)];
    stat_param(:,4) = [param(:,5);nan(10000,1)];
    format shorte
    [p,tbl,stats] = kruskalwallis(stat_param);
    c = multcompare(stats);
    c(:,[1,2,end])
    format short
end



