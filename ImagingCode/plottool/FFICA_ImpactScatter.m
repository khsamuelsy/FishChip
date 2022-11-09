function FFICA_ImpactScatter(options)

global mycolor allbrain plotdata

impact_all = [];
nregionid_all = [];

for ii=1:length(allbrain.fishn)
    impact_mean = [];
    thisbrain = allbrain.data{ii};
    mi_ar= thisbrain.cal2.mi_ar;
    mi = thisbrain.cal2.mi(:,3);
    maxs = thisbrain.cal2.maxs;
    impact = (mi-mi_ar')./mi;
    sens_thres = 2.5*max(max(thisbrain.cal2.mi_perm(:,1:3)));
    
    validlist=intersect(find(~isnan(impact)),find(mi>sens_thres));
    thislist=intersect(validlist,find(maxs(:,3)~=0));
    if options.larvae_averaged
        regionid_l = [89,279,283,291,15,60,1,94,131,114];
        regionid_r = regionid_l+294;
        regionid_b = [regionid_l,regionid_r];
        
        for jj=1:10
            indx = union(find(thisbrain.regionid==regionid_l(jj)),find(thisbrain.regionid==regionid_l(jj)+294));
            indx2 = intersect(indx,thislist);
            impact_mean(jj) = mean(impact(indx2));
        end
        
        impact_all = [impact_all, impact_mean];
        nregionid_all = [nregionid_all, regionid_l];
    else
        thisbrain.regionid(thisbrain.regionid>294)=thisbrain.regionid(thisbrain.regionid>294)-294;
        impact_all = [impact_all; impact(thislist)];
        nregionid_all = [nregionid_all; thisbrain.regionid(thislist)];
    end
end
impact_all(impact_all<-1) = -1;
if options.larvae_averaged
    options.scattercolor=repmat(0.5,1,3);
    options.scatterpoint=5;
    options.clearscatter = true;
else
    options.scattercolor=repmat(0.65,1,3);
    options.scatterpoint=1;
    options.clearscatter = false;
    
end
options.set_yticks = [-1:1];
options.grouping = 'unified';
options.fign =1;
options.colorscheme = customcolormap_preset('purple-white-green')*.9;
data.qty=impact_all;
data.nregionid_all=nregionid_all;

plotdata=[];

regionid_l = [89,279,283,291,15,60,1,94,131,114];
for ii=1:10
    plotdata(:,ii) = [data.qty(find(data.nregionid_all==regionid_l(ii)));repmat(nan,10000-length(data.qty(find(data.nregionid_all==regionid_l(ii)))),1)];
    
end

options.pt_spread = 7.2;
options.pt_spread_portion = 20;
options.uniproxi = false;
options.parametric = false;
options.logtransform = false;
options.violin_spread = 0.14;
options.set_yticks = [-1:1];
options.skiplastyticks = false;
FFICA_BoxViolinPlot_2(plotdata,options)

end