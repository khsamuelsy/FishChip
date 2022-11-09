function FFICA_SensoryMap_df(Ioptions)

global mycolor allbrain

ffica_colorplate;
dimension = {'z','y','x'};

for kk=1:3
    for jj=1:3
        for ii=1:length(allbrain.fishn)
            thisbrain = allbrain.data{ii};
            maxs = thisbrain.df.maxs(:,5:7);
            if Ioptions.ifnormalized
                lOB_roi = find(thisbrain.regionid==279);
                rOB_roi = find(thisbrain.regionid==279+294);
                bOB_roi = union(lOB_roi,rOB_roi);
                average_maxs_lOB = mean(maxs(lOB_roi,1));
                average_maxs_rOB = mean(maxs(rOB_roi,2));
                average_maxs_bOB = mean(maxs(bOB_roi,3));
                maxs(:,1) = maxs(:,1)./ average_maxs_lOB;
                maxs(:,2) = maxs(:,2)./ average_maxs_rOB;
                maxs(:,3) = maxs(:,3)./ average_maxs_bOB;
            end
            
            data={};
            data.qty = maxs(:,kk);
            data.seq_fish = ii;
            data.thisbrain = thisbrain;
            data.list=thisbrain.shlist.sens;
            length(data.list)
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
                options.fign = jj+(kk-1)*3;
                options.crange = Ioptions.crange;
                J = magma(70);
                J = J(7:70,:);
                options.colormap = flip(J,1);
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
end



