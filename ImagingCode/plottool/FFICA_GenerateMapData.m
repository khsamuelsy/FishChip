function FFICA_GenerateMapData(data,options)

global mycolor map allbrain count

hs_f = 3; %hs_factor
if data.seq_fish==1
    if options.type=='z'
        map=NaN(679*hs_f,300*hs_f);
        count=zeros(679*hs_f,300*hs_f);
    elseif options.type=='y'
        map=NaN(679*hs_f,138*hs_f);
        count=zeros(679*hs_f,138*hs_f);
    elseif options.type=='x'
        map=NaN(138*hs_f,300*hs_f);
        count=zeros(138*hs_f,300*hs_f);
    end
end
meanrc = zeros(size(data.thisbrain.signal3,1),3);
for kk=1:size(data.thisbrain.signal3,1)
    % different image dimensions of different image groups
    if allbrain.fishn(data.seq_fish)>400
        ImRaw2_dispspatial=reshape(full(data.thisbrain.A2(:,kk)),[1600,800]);
    elseif allbrain.fishn(data.seq_fish)>300
        ImRaw2_dispspatial=reshape(full(data.thisbrain.A2(:,kk)),[1408,792]);
    end
    L_spatial=logical(ImRaw2_dispspatial);
    [r,c] = find(L_spatial(:,:));
    mr = round(mean(r));
    mc = round(mean(c));
    % different image dimensions of different image groups
    meanrc(kk,:) = [mc,mr,data.thisbrain.regdata.corr_plane(data.thisbrain.planeid(kk),2)];
end
rOE_indx = find(data.thisbrain.regionid==89+294);
pause(0.01)
[n_voxels,indx]=FFICA_Map2RefBrain(meanrc,data.thisbrain,allbrain.fishn(data.seq_fish),rOE_indx);

data.thisbrain.n_voxels = n_voxels;
remove_list = [];
count0=0;


for ii=1:length(indx)
    if ~any(data.list==indx(ii))
        remove_list=[remove_list;ii];
        count0=count0+1;
    end
end
indx(remove_list)=[];
load('RegionOutline');
for kk=1:size(data.thisbrain.signal3,1)
    
    x = n_voxels(kk,1);    y = n_voxels(kk,2);    z = n_voxels(kk,3);
    
    if x>0 & y>0 & z>0 & ...
            x<=300 & y<=679 & z<=138
        if options.type=='z'
            if withinoutline_z_all(y*hs_f,x*hs_f)
                
                if any(indx==kk) && x ~= 0 && y ~= 0
                    
                    if ~options.meanflag
                        for ii=x*hs_f-hs_f*2:x*hs_f+hs_f*2
                            for jj=y*hs_f-hs_f*2:y*hs_f+hs_f*2
                                % slightly out of bound used 'try'
                                try
                                    if pdist([ii,jj;x*hs_f,y*hs_f])<=hs_f*2
                                        map(jj,ii) = max(data.qty(kk),map(jj,ii));
                                        count(jj,ii) = count(jj,ii)+1;
                                    end
                                end
                            end
                        end
                    else
                        for ii=x*hs_f-hs_f*2:x*hs_f+hs_f*2
                            for jj=y*hs_f-hs_f*2:y*hs_f+hs_f*2
                                if pdist([ii,jj;x*hs_f,y*hs_f])<=hs_f*2
                                    if isnan(map(jj,ii))
                                        map(jj,ii) = data.qty(kk);
                                    else
                                        map(jj,ii) = map(jj,ii)+data.qty(kk);
                                    end
                                    
                                    count(jj,ii) = count(jj,ii)+1;
                                end
                            end
                        end
                    end
                end
            end
            
        elseif options.type=='y'
            
            if withinoutline_y_all(y*hs_f,z*hs_f)
                if any(indx==kk) && z ~= 0 && y ~= 0
                    if ~options.meanflag
                        for ii=z*hs_f-hs_f*2:z*hs_f+hs_f*2
                            for jj=y*hs_f-hs_f*2:y*hs_f+hs_f*2
                                if pdist([ii,jj;z*hs_f,y*hs_f])<=hs_f*2
                                    map(jj,ii) = max(data.qty(kk),map(jj,ii));
                                    count(jj,ii) = count(jj,ii)+1;
                                end
                            end
                        end
                    else
                        for ii=z*hs_f-hs_f*2:z*hs_f+hs_f*2
                            for jj=y*hs_f-hs_f*2:y*hs_f+hs_f*2
                                if pdist([ii,jj;z*hs_f,y*hs_f])<=hs_f*2
                                    
                                    try
                                        if isnan(map(jj,ii))
                                            map(jj,ii) = data.qty(kk);
                                        else
                                            map(jj,ii) = map(jj,ii)+data.qty(kk);
                                        end
                                        count(jj,ii) = count(jj,ii)+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elseif options.type=='x'
            
            if withinoutline_x_all(z*hs_f,x*hs_f)
                if any(indx==kk) && x ~= 0 && z ~= 0
                    if ~options.meanflag
                        for ii=x*hs_f-hs_f*2:x*hs_f+hs_f*2
                            for jj=z*hs_f-hs_f*2:z*hs_f+hs_f*2
                                if pdist([ii,jj;x*hs_f,z*hs_f])<=hs_f*2
                                    map(jj,ii) = max(data.qty(kk),map(jj,ii));
                                    count(jj,ii) = count(jj,ii)+1;
                                end
                            end
                        end
                    else
                        for ii=x*hs_f-hs_f*2:x*hs_f+hs_f*2
                            for jj=z*hs_f-hs_f*2:z*hs_f+hs_f*2
                                if pdist([ii,jj;x*hs_f,z*hs_f])<=hs_f*2
                                    try
                                        if isnan(map(jj,ii))
                                            map(jj,ii) = data.qty(kk);
                                        else
                                            map(jj,ii) = map(jj,ii)+data.qty(kk);
                                        end
                                        count(jj,ii) = count(jj,ii)+1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
    end
end
end