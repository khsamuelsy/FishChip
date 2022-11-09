function FFICA_Sensory_Scatter_Area

global mycolor allbrain

dimension = {'z','y','x'};
ffica_colorplate;


close all

area_all = [];area_all2 = [];
nregionid_all = [];nregionid_all2 = [];

for ii=1:length(allbrain.fishn)
    area_mean = [];
    area_mean2 = [];
    thisbrain = allbrain.data{ii};
    arearatio= thisbrain.cal2.area.bi./thisbrain.cal2.area.uni;
    arearatio_bi= thisbrain.cal2.area.bi;
    arearatio_uni= thisbrain.cal2.area.uni;
    sens_thres = 2.5*max(max(thisbrain.cal2.mi_perm(:,1:3)));
    shlist.sens = find(thisbrain.cal2.mi(:,1)>sens_thres | ...
        thisbrain.cal2.mi(:,2)>sens_thres | ...
        thisbrain.cal2.mi(:,3)>sens_thres ...
        );
    validlist=intersect(find(~isnan(arearatio)),shlist.sens);
    
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

plotdata(:,1) = [area_all(find(nregionid_all==89));repmat(nan,10000-length(area_all(find(nregionid_all==89))),1)];
plotdata(:,3) = [area_all(find(nregionid_all==279));repmat(nan,10000-length(area_all(find(nregionid_all==279))),1)];
plotdata(:,5) = [area_all(find(nregionid_all==283));repmat(nan,10000-length(area_all(find(nregionid_all==283))),1)];
plotdata(:,7) = [area_all(find(nregionid_all==291));repmat(nan,10000-length(area_all(find(nregionid_all==291))),1)];
plotdata(:,9) = [area_all(find(nregionid_all==15));repmat(nan,10000-length(area_all(find(nregionid_all==15))),1)];
plotdata(:,11) = [area_all(find(nregionid_all==60));repmat(nan,10000-length(area_all(find(nregionid_all==60))),1)];
plotdata(:,13) = [area_all(find(nregionid_all==1));repmat(nan,10000-length(area_all(find(nregionid_all==1))),1)];
plotdata(:,15) = [area_all(find(nregionid_all==94));repmat(nan,10000-length(area_all(find(nregionid_all==94))),1)];
plotdata(:,17) = [area_all(find(nregionid_all==114));repmat(nan,10000-length(area_all(find(nregionid_all==114))),1)];
plotdata(:,19) = [area_all(find(nregionid_all==131));repmat(nan,10000-length(area_all(find(nregionid_all==131))),1)];

plotdata(:,2) = [area_all2(find(nregionid_all==89));repmat(nan,10000-length(area_all2(find(nregionid_all==89))),1)];
plotdata(:,4) = [area_all2(find(nregionid_all==279));repmat(nan,10000-length(area_all2(find(nregionid_all==279))),1)];
plotdata(:,6) = [area_all2(find(nregionid_all==283));repmat(nan,10000-length(area_all2(find(nregionid_all==283))),1)];
plotdata(:,8) = [area_all2(find(nregionid_all==291));repmat(nan,10000-length(area_all2(find(nregionid_all==291))),1)];
plotdata(:,10) = [area_all2(find(nregionid_all==15));repmat(nan,10000-length(area_all2(find(nregionid_all==15))),1)];
plotdata(:,12) = [area_all2(find(nregionid_all==60));repmat(nan,10000-length(area_all2(find(nregionid_all==60))),1)];
plotdata(:,14) = [area_all2(find(nregionid_all==1));repmat(nan,10000-length(area_all2(find(nregionid_all==1))),1)];
plotdata(:,16) = [area_all2(find(nregionid_all==94));repmat(nan,10000-length(area_all2(find(nregionid_all==94))),1)];
plotdata(:,18) = [area_all2(find(nregionid_all==114));repmat(nan,10000-length(area_all2(find(nregionid_all==114))),1)];
plotdata(:,20) = [area_all2(find(nregionid_all==131));repmat(nan,10000-length(area_all2(find(nregionid_all==131))),1)];

options.pt_spread = 2;
options.pt_spread_portion = 20;
options.uniproxi = false;
options.parametric = false;
options.logtransform = false;
options.violin_spread = 0.025;
options.skiplastyticks = false;

FFICA_ScatterLinePlot_1(plotdata,options)

% signrank stat test, paired
p1 = signrank(plotdata(:,1),plotdata(:,2));
p2 = signrank(plotdata(:,3),plotdata(:,4));
p3 = signrank(plotdata(:,5),plotdata(:,6));
p4 = signrank(plotdata(:,7),plotdata(:,8));
p5 = signrank(plotdata(:,9),plotdata(:,10));
p6 = signrank(plotdata(:,11),plotdata(:,12));
p7 = signrank(plotdata(:,13),plotdata(:,14));
p8 = signrank(plotdata(:,15),plotdata(:,16));
p9 = signrank(plotdata(:,17),plotdata(:,18));
p10 = signrank(plotdata(:,19),plotdata(:,20));
for ii=1:10
    display(num2str(eval(['p',num2str(ii)])))
end
xlim([-.5 21.5])
end