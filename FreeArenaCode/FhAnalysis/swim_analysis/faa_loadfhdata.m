function faa_loadfhdata

global data

CurrentDir = pwd;
CurrentDir = [CurrentDir(1:end-46),'Data\pulled_2_plus_static\'];

input_flag = 0;

while input_flag == 0
    
    DataSet = input ...
        ('Which data sets to analyze?\n[11: GC(non-ablated) - water]\n[12: GC(non-ablated) - cadaverine]\n[21: GC(left-ablated) - cadaverine]\n[22: GC(right-ablated) - cadaverine]\n[23: GC(Bi-ablated) - cadaverine]\n[30: Static]\n');
    input_flag = 1;
    
    if floor(DataSet/10) == 1
        if mod(DataSet,10) == 1
            CurrentDir = [CurrentDir, 'Intact Water'];
        elseif mod(DataSet,10) == 2
            CurrentDir = [CurrentDir, 'Intact Cadaverine'];
        else
            error('Invalid input');
            input_flag=0;
        end
        
    elseif floor(DataSet/10) == 2
        
        if mod(DataSet,10) == 1
            CurrentDir = [CurrentDir, 'L-aba cadaverine'];
        elseif mod(DataSet,10) == 2
            CurrentDir = [CurrentDir, 'R-aba cadaverine'];
        elseif mod(DataSet,10) == 3
            CurrentDir = [CurrentDir, 'Bi-aba cadaverine'];
        else
            error('Invalid input');
            input_flag=0;
        end
    elseif floor(DataSet/10) ==3
        
        CurrentDir = [CurrentDir, 'Static'];
        
    else
        error('Invalid input');
        input_flag=0;
    end
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

display(['Loaded All Data']);     






