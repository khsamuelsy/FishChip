function FFICA_SelectivityScatter(options)

global mycolor allbrain
dimension = {'z','y','x'};
ffica_colorplate;

sel_all = [];nregionid_all = [];


for ii=1:length(allbrain.fishn)
    sel_mean = [];
    thisbrain = allbrain.data{ii};
    mi = thisbrain.cal2.mi;
    sel = zeros(size(mi,1),1);
    
    sens_thres = 2.5*max(max(thisbrain.cal2.mi_perm(:,1:3)));
        bi_indx = find(mi(:,1)>sens_thres | ...
            mi(:,2)>sens_thres | ...
            mi(:,3)>sens_thres); % select roi based on response to bilateral case
    thislist = bi_indx;

    l_brain_indx = intersect(find(thisbrain.regionid<=294),thislist);
    r_brain_indx = intersect(find(thisbrain.regionid>294),thislist);
    
    sel(l_brain_indx) = mi(l_brain_indx,1)./(mi(l_brain_indx,1)+mi(l_brain_indx,2));
    sel(r_brain_indx) = mi(r_brain_indx,2)./(mi(r_brain_indx,1)+mi(r_brain_indx,2));
    
    if options.larvae_averaged
        regionid_l = [89,279,283,291,15,60,1,94,131,114]; % remember the order of 9/10 has been changed
        regionid_r = regionid_l+294;
        regionid_b = [regionid_l,regionid_r];
        for jj=1:10
            indx = union(find(thisbrain.regionid==regionid_l(jj)),find(thisbrain.regionid==regionid_l(jj)+294));
            indx2 = intersect(indx,thislist);
            sel_mean(jj) = mean(sel(indx2));
        end
        sel_all = [sel_all, sel_mean];
        nregionid_all = [nregionid_all, regionid_l];
    else
        thisbrain.regionid(thisbrain.regionid>294)=thisbrain.regionid(thisbrain.regionid>294)-294;
        sel_all = [sel_all; sel(thislist)];
        nregionid_all = [nregionid_all; thisbrain.regionid(thislist)];
    end
    t= intersect(intersect(find(thisbrain.regionid==89),thislist),find(sel<0.5)); 
end


if options.larvae_averaged
    
    options.scattercolor=repmat(0.5,1,3);
    options.scatterpoint=5;
    options.clearscatter = true;
else
    options.scattercolor=repmat(0.65,1,3);
    options.scatterpoint=1;
    options.clearscatter = false;
    
end
options.set_yticks = [-0.5:0.5:0.5];

options.grouping = 'unified';
options.fign =1;
J = magma(70);
J = J(7:70,:);
options.colorscheme = J;
data.qty=sel_all-0.5;
data.nregionid_all=nregionid_all;

FFICA_BrainRegionScatter(data,options)

end

