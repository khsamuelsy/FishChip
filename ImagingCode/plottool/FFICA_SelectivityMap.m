function FFICA_SelectivityMap(Ioptions)

global mycolor allbrain

ffica_colorplate;
dimension={'z','y','x'};

for jj=1:3
    for ii=1:length(allbrain.fishn)
        % calculate quantity
        thisbrain = allbrain.data{ii};
        mi = thisbrain.cal2.mi;
        sel = zeros(size(thisbrain.cal2.mi,1),1);
        sens_thres = 2.5*max(max(thisbrain.cal2.mi_perm(:,1:3)));
        bi_indx = find(mi(:,1)>sens_thres | ...
            mi(:,2)>sens_thres | ...
            mi(:,3)>sens_thres); % select roi based on response to bilateral case
        thislist = bi_indx;
        l_brain_indx = intersect(find(thisbrain.regionid<=294),thislist);
        r_brain_indx = intersect(find(thisbrain.regionid>294),thislist);
        sel(l_brain_indx) = mi(l_brain_indx,1)./(mi(l_brain_indx,1)+mi(l_brain_indx,2));
        sel(r_brain_indx) = mi(r_brain_indx,2)./(mi(r_brain_indx,1)+mi(r_brain_indx,2));
        data={};
        data.qty = sel;
        data.seq_fish = ii;
        data.thisbrain = thisbrain;
        data.list=thislist;
        options.type = dimension{jj};
        options.meanflag = Ioptions.meanflag;
        display(['Generating Map Data : ', num2str(ii),'/',num2str(length(allbrain.fishn))])
        tic
        % generate map data
        FFICA_GenerateMapData(data,options);
        toc
        display(['Done'])
        if ii == length(allbrain.fishn)
            global map count
            options={};
            options.fign = jj; % figure number
            options.crange = Ioptions.crange; % color range
            J = magma(70); % color map
            J = J(7:70,:); % refine color map
            options.colormap = J;
            options.type=dimension{jj};
            if Ioptions.meanflag==false
                mapdata = map;
            else
                mapdata = map./count;
            end
            FFICA_BrainMap(mapdata,options)% generate brain map at this step
        end
    end
end
end




