global data border results_cb test

FAA_loadborder
DataSet = [10,20,30,40,50];

for p=1:size(DataSet,2)
    tic
    display(['Processing DataSet ...',num2str(DataSet(p))]);
    OriDir = pwd;
    CurrentDir = [OriDir(1:end-46),'Results\data\'];
    cd(CurrentDir);
    results_cb{p}.datasetno=DataSet(p);
    if floor(DataSet(p)/10) == 1
        load('PR_Intact_Water.mat')
        CurrentDir = [OriDir(1:end-46),'Data\pulled_2\Intact Water\'];
    elseif floor(DataSet(p)/10) == 2
        load('PR_Intact_Cadaverine.mat')
        CurrentDir = [OriDir(1:end-46),'Data\pulled_2\Intact cadaverine\'];
    elseif floor(DataSet(p)/10) == 3
        load('PR_L-aba_Cadaverine.mat')
        CurrentDir = [OriDir(1:end-46),'Data\pulled_2\L-aba cadaverine\'];
    elseif floor(DataSet(p)/10) == 4
        load('PR_R-aba_Cadaverine.mat')
        CurrentDir = [OriDir(1:end-46),'Data\pulled_2\R-aba cadaverine\'];
    elseif floor(DataSet(p)/10) == 5
        load('PR_Bi-aba_Cadaverine.mat')
        CurrentDir = [OriDir(1:end-46),'Data\pulled_2\Bi-aba cadaverine\'];
    end
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
    cd (CurrentDir);
    for i=1:data.nfiles
        load(DataSet_names(i,:));
        data.FhCoor=[data.FhCoor,FhData_filtered.FhCoor];
        data.FhAng=[data.FhAng,FhData_filtered.FhAng];
        data.noffish=data.noffish+size(FhData_filtered.FhCoor,2);
        clearvars FhData_filtered
    end
    data.filenames=DataSet_names;
    cd(OriDir);
    dnormal_time={};
    count_no_of_crossing_both_sides=0;
    zone_2=14;    zone_1=10;
    if zone_1==20
        display('now plotting stimuli zone')
    else
        display('now plotting control zone')
    end
    for i=1:size(results.bordercrossing_details,2)
        for j=1:size(results.bordercrossing_details{1,i},1)
            count_no_of_crossing_both_sides=count_no_of_crossing_both_sides+1;
            dnormal_time{count_no_of_crossing_both_sides}=[];

            if  results.bordercrossing_details{1,i}(j,5)<zone_2 && ...
                    (results.bordercrossing_details{1,i}(j,5)>zone_1 || (results.bordercrossing_details{1,i}(j,5)==0 && results.bordercrossing_details{1,i}(j,6)>zone_1 &&results.bordercrossing_details{1,i}(j,6)<zone_2  ))  && ...
                    ~isnan(results.bordercrossing_details{1,i}(j,4))
                for k=results.bordercrossing_details{1,i}(j,1):results.bordercrossing_details{1,i}(j,4)
                    dnormal_time{count_no_of_crossing_both_sides}=[dnormal_time{count_no_of_crossing_both_sides}; ...
                        (k-results.bordercrossing_details{1,i}(j,1))/(results.bordercrossing_details{1,i}(j,4)-results.bordercrossing_details{1,i}(j,1)), ...
                        cosd(data.FhAng{1,i}(k)-results.bordercrossing_details{1,i}(j,12))];

                    if isnan(data.FhAng{1,i}(k))
                        dnormal_time{count_no_of_crossing_both_sides}=[];
                        break
                    end
                    
                end
            end
        end
        display([num2str(i),'/',num2str(size(results.bordercrossing_details,2)  )])
        
    end
    results_cb{p}.dnormal_time=dnormal_time;
    toc
end

