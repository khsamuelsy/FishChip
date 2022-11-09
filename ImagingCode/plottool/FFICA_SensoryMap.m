function FFICA_SensoryMap(Ioptions)


global mycolor allbrain

ffica_colorplate;
dimension = {'z','y','x'};

for kk=1:3
    for jj=1:3
        for ii=1:length(allbrain.fishn)
            thisbrain = allbrain.data{ii};
            mi = thisbrain.cal2.mi;
          
            if Ioptions.ifnormalized
                lOB_roi = find(thisbrain.regionid==279);
                rOB_roi = find(thisbrain.regionid==279+294);
                bOB_roi = union(lOB_roi,rOB_roi);
                average_mi_lOB = mean(mi(lOB_roi,1));
                average_mi_rOB = mean(mi(rOB_roi,2));
                average_mi_bOB = mean(mi(bOB_roi,3));
                mi(:,1) = mi(:,1)./ average_mi_lOB;
                mi(:,2) = mi(:,2)./ average_mi_rOB;
                mi(:,3) = mi(:,3)./ average_mi_bOB;
            end
            
            data={};
            data.qty = mi(:,kk);
            data.seq_fish = ii;
            data.thisbrain = thisbrain;
            data.list = thisbrain.shlist.sens;
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
                J = magma(70);  J = J(7:70,:);
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



