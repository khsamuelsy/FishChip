function FFICA_MotorScatter(Ioptions)

global mycolor allbrain
dimension = {'z','y','x'};
ffica_colorplate;

mi_all = [];data.nregionid_all = [];fraction_cal_all = [];

motoralt=false;
for ii=1:length(allbrain.fishn)
    mi_mean = [];
    mi_mean2=[];
    fraction_cal1 = [];
    fraction_cal2 = [];
    fraction_cal3 = [];
    thisbrain = allbrain.data{ii};
    mi = thisbrain.cal2.mi;
    
    if motoralt
        qty_perm = thisbrain.cal2_motoralt.mi_perm;
        qty = thisbrain.cal2_motoralt.mi;
        qty_perm_2 =  thisbrain.cal2.mi_perm(:,4);
        qty_2= thisbrain.cal2.mi(:,4);
        moto_thres = 1.25*max(qty_perm);
        moto_thres_2 = 1.25*max(qty_perm_2);
        shlist.moto = intersect(find(qty>moto_thres),find(qty_2>moto_thres_2));
    else
        qty_perm =  thisbrain.cal2.mi_perm(:,4);
        qty= thisbrain.cal2.mi(:,4);
        qty_perm_2 = thisbrain.cal2_motoralt.mi_perm;
        qty_2 = thisbrain.cal2_motoralt.mi;
        
        moto_thres = 2.5*max(qty_perm);
        moto_thres_2 = 1.25*max(qty_perm_2);
        shlist.moto = (find(qty>moto_thres));
    end

    regionid_l = [89,279,283,291,15,60,1,94,131,114];
    regionid_r = regionid_l+294;
    regionid_b = [regionid_l,regionid_r];
    
    for jj=1:20
        fraction_cal(jj,:) = [jj, length(find(thisbrain.regionid(shlist.moto)==regionid_b(jj)))./ ...
            length(find(thisbrain.regionid==regionid_b(jj)))];
    end
    fraction_cal_all = [fraction_cal_all;fraction_cal];
    
    if Ioptions.larvae_averaged
        for jj=1:20
            indx = intersect(find(thisbrain.regionid==regionid_b(jj)),shlist.moto);
            mi_mean(jj) = mean(qty(indx));
        end
        
        mi_all = [mi_all, mi_mean];
        data.nregionid_all = [data.nregionid_all, regionid_b];
        
    else
        mi_all = [mi_all; qty(shlist.moto)];
        data.nregionid_all = [data.nregionid_all; thisbrain.regionid(shlist.moto)];
        
    end
end

for jj=1:20
    indx = find(fraction_cal_all(:,1)==jj);
    fraction_local(jj) = mean(fraction_cal_all(indx,2));
end
    data.qty=mi_all;
    % cap max
    if isfield(Ioptions,'max_xvalue')
        data.qty(data.qty>Ioptions.max_xvalue) = Ioptions.max_xvalue;
        options.max_xvalue = Ioptions.max_xvalue;
    end
    data.fraction = fraction_local;
    options.setxticks = Ioptions.setxticks;
    options.setxticks_fraction = Ioptions.setxticks_fraction;
    options.fign = 1;
    options.grouping = 'lateralized';
    options.barset = [7,8,10];
        if Ioptions.larvae_averaged
        options.scatterpoint = 5;
    else
        options.scatterpoint = 2;
    end
    FFICA_BrainRegionScatter_Motor(data,options)
end

