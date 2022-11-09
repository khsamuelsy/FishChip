function FFICA_SensoryScatter_df(Ioptions)

global mycolor allbrain
dimension = {'z','y','x'};
ffica_colorplate;

maxs_all = [];
data.nregionid_all = [];
fraction_cal_all1 = [];
fraction_cal_all2 = [];
fraction_cal_all3 = [];

for ii=1:length(allbrain.fishn)
    
    maxs_mean = [];

    fraction_cal1 = [];
    fraction_cal2 = [];
    fraction_cal3 = [];
    thisbrain = allbrain.data{ii};
    maxs = thisbrain.df.maxs(:,5:8);

    sens_thres = 2.5* ...
        max(max(thisbrain.cal2.mi_perm(:,1:3)));

    shlist.sens1 = find(thisbrain.cal2.mi(:,1)>sens_thres);
    shlist.sens2 = find(thisbrain.cal2.mi(:,2)>sens_thres);
    shlist.sens3 = find(thisbrain.cal2.mi(:,3)>sens_thres);

    regionid_l = [89,279,283,291,15,60,1,94,131,114]; % remember the order of 9/10 has been changed
    regionid_r = regionid_l+294;
    regionid_b = [regionid_l,regionid_r];
    
    for jj=1:20


        fraction_cal1(jj,:) = [jj, length(find(thisbrain.regionid(shlist.sens1)==regionid_b(jj)))./ ...
            length(find(thisbrain.regionid==regionid_b(jj)))];
        fraction_cal2(jj,:) = [jj, length(find(thisbrain.regionid( shlist.sens2)==regionid_b(jj)))./ ...
            length(find(thisbrain.regionid==regionid_b(jj)))];
        fraction_cal3(jj,:) = [jj, length(find(thisbrain.regionid(shlist.sens3)==regionid_b(jj)))./ ...
            length(find(thisbrain.regionid==regionid_b(jj)))];
    end
    fraction_cal_all1 = [fraction_cal_all1;fraction_cal1];
    fraction_cal_all2 = [fraction_cal_all2;fraction_cal2];
    fraction_cal_all3 = [fraction_cal_all3;fraction_cal3];

    if Ioptions.larvae_averaged
        for jj=1:20
            indx = intersect(find(thisbrain.regionid==regionid_b(jj)),thisbrain.shlist.sens);
            maxs_mean(jj,1:3) = nanmean(maxs(indx,1:3));
        end
       
        maxs_all = [maxs_all; maxs_mean];
        data.nregionid_all = [data.nregionid_all, regionid_b];

    else
        maxs_all = [maxs_all; maxs(thisbrain.shlist.sens,1:3)];
        data.nregionid_all = [data.nregionid_all; thisbrain.regionid(thisbrain.shlist.sens)];
        
    end
end

for jj=1:20
    indx = find(fraction_cal_all1(:,1)==jj);
    fraction_local(jj,1) = nanmean(fraction_cal_all1(indx,2));
end
for jj=1:20
    indx = find(fraction_cal_all2(:,1)==jj);
    fraction_local(jj,2) = nanmean(fraction_cal_all2(indx,2));
end
for jj=1:20
    indx = find(fraction_cal_all3(:,1)==jj);
    fraction_local(jj,3) = nanmean(fraction_cal_all3(indx,2));
end

for jj=1:3
    data.qty=maxs_all(:,jj);
    % cap max
    if isfield(Ioptions,'max_xvalue')
        data.qty(data.qty>Ioptions.max_xvalue) = Ioptions.max_xvalue;
        options.max_xvalue = Ioptions.max_xvalue;
    end
    data.fraction = eval(['fraction_local(:,',num2str(jj),');']);
    options.setxticks = Ioptions.setxticks;
    options.setxticks_fraction = Ioptions.setxticks_fraction;
    options.fign = jj;
    options.barset = [1:6];
    options.grouping = 'lateralized';
    options.noOE = false;
    if Ioptions.larvae_averaged
        options.scatterpoint = 5;
    else
        options.scatterpoint = 2;
    end
    FFICA_BrainRegionScatter(data,options)
end

end

