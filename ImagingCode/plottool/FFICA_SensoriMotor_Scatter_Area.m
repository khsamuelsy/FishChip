function FFICA_SensoriMotor_Scatter_Area

global mycolor allbrain

dimension = {'z','y','x'};
ffica_colorplate;

close all

area_all = []; area_all2 = [];
nregionid_all = []; nregionid_all2 = [];

for ii=1:length(allbrain.fishn)
    area_mean = [];
    area_mean2 = [];
    thisbrain = allbrain.data{ii};
    arearatio= thisbrain.cal2.area.bi./thisbrain.cal2.area.uni;
    arearatio_bi= thisbrain.cal2.area.bi;
    arearatio_uni= thisbrain.cal2.area.uni;
    
    qty_perm =  thisbrain.cal2.mi_perm(:,4);
    qty= thisbrain.cal2.mi(:,4);
    moto_thres = 1.25*max(qty_perm);
    shlist.moto = find(qty>moto_thres);
    sens_thres = 1.25*max(max(thisbrain.cal2.mi_perm(:,1:3)));
    shlist.sens = find(thisbrain.cal2.mi(:,1)>sens_thres | ...
        thisbrain.cal2.mi(:,2)>sens_thres | ...
        thisbrain.cal2.mi(:,3)>sens_thres ...
        );
    
    semo_list = intersect(shlist.sens,shlist.moto);

    validlist=intersect(find(~isnan(arearatio)), semo_list);

    regionid_l = [89,279,283,291,15,60,1,94,131,114]; 
    regionid_r = regionid_l+294;
    regionid_b = [regionid_l,regionid_r];
    for jj=1:10
        indx = union(find(thisbrain.regionid==regionid_l(jj)),find(thisbrain.regionid==regionid_l(jj)+294));
        indx2 = intersect(indx,validlist);
        area_mean(jj) = mean(arearatio_uni(indx2));
        area_mean2(jj) = mean(arearatio_bi(indx2));
    end
    
    area_all = [area_all; area_mean'];
    area_all2 = [area_all2;area_mean2'];
    nregionid_all = [nregionid_all; regionid_l'];
    nregionid_all2 = [nregionid_all2; regionid_l'];
    
    
end

plotdata=[];
plotdata(:,1) = [area_all(find(nregionid_all==1));repmat(nan,10000-length(area_all(find(nregionid_all==1))),1)];
plotdata(:,3) = [area_all(find(nregionid_all==94));repmat(nan,10000-length(area_all(find(nregionid_all==94))),1)];
plotdata(:,5) = [area_all(find(nregionid_all==114));repmat(nan,10000-length(area_all(find(nregionid_all==114))),1)];

plotdata(:,2) = [area_all2(find(nregionid_all==1));repmat(nan,10000-length(area_all2(find(nregionid_all==1))),1)];
plotdata(:,4) = [area_all2(find(nregionid_all==94));repmat(nan,10000-length(area_all2(find(nregionid_all==94))),1)];
plotdata(:,6) = [area_all2(find(nregionid_all==114));repmat(nan,10000-length(area_all2(find(nregionid_all==114))),1)];

options.pt_spread = 2;
options.pt_spread_portion = 20;
options.uniproxi = false;
options.parametric = false;
options.logtransform = false;
options.violin_spread = 0.025;
options.skiplastyticks = false;

FFICA_ScatterLinePlot_2(plotdata,options)

p1 = signrank(plotdata(:,1),plotdata(:,2));
p2 = signrank(plotdata(:,3),plotdata(:,4));
p3 = signrank(plotdata(:,5),plotdata(:,6));

end