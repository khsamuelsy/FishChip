function FFICA_ImpactMap(Ioptions)

global mycolor allbrain

ffica_colorplate;
dimension = {'z','y','x'};

for jj=1:3
    for ii=1:length(allbrain.fishn)

        thisbrain = allbrain.data{ii};
        mi_ar= thisbrain.cal2.mi_ar;
        mi = thisbrain.cal2.mi(:,3);
        impact = (mi-mi_ar')./mi;
        sens_thres = 2.5*max(max(thisbrain.cal2.mi_perm(:,1:3)));
        validlist=intersect(find(~isnan(impact)),find(mi>sens_thres));
        thislist=intersect(validlist,thisbrain.shlist.sens);
        
        J = customcolormap_preset('purple-white-green')*.9;
        data={};
        data.qty = impact;
        data.seq_fish = ii;
        data.thisbrain = thisbrain;
        data.list=thislist;
      
        options.type = dimension{jj};
        options.meanflag = Ioptions.meanflag;
        
        
        display(['Generating Map Data : ', num2str(ii),'/',num2str(length(allbrain.fishn))])
        tic
        FFICA_GenerateMapData(data,options);
        toc
        display(['Done'])
        
        if ii == length(allbrain.fishn)
            global map count
            options={};
            options.fign = jj;
            options.crange = Ioptions.crange;
            J = customcolormap_preset('purple-white-green')*.9;
            options.colormap = J;
            options.type=dimension{jj};
            if Ioptions.meanflag==false
                mapdata = map;
            else
                mapdata = map./count;
            end
            FFICA_BrainMap(mapdata,options)
        end
    end
end
end




