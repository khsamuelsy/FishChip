function faa_findtimespent

global data results


results.timespent={};

for i=1:data.noffish
    count_0 = 0;
    count_1 = 0;
    count_2 = 0;
    nan_flag = 0;
    for j=1:1728000
        if ~isnan(data.FhCoor{1,i}(j,1)) ...
                & ~isnan(data.FhCoor{1,i}(j,2))

            zone_id = FAA_zoneid(data.FhCoor{1,i}(j,1),data.FhCoor{1,i}(j,2));
            nan_flag=0;
            if zone_id == 13 | zone_id == 12
                count_1 = count_1+1;
            elseif zone_id == 23 | zone_id == 22
                count_2 = count_2+1;
            elseif zone_id == 11 | zone_id == 21 | zone_id == 0
                count_0 = count_0+1;

            end
        else
            if nan_flag==0
                m=find(~isnan(data.FhCoor{1,i}(1:j,1)));
            end
            nan_flag=1;
            if size(m,1)~=0
                zone_id = FAA_zoneid(data.FhCoor{1,i}(m(end),1),data.FhCoor{1,i}(m(end),2));
                if zone_id == 13 | zone_id == 12
                    count_1 = count_1+1;
                elseif zone_id == 23 | zone_id == 22
                    count_2 = count_2+1;
                elseif zone_id == 11 | zone_id == 21 | zone_id == 0
                    count_0 = count_0+1;
                end
            end
        end
        if mod(j,100000) ==0
            display([num2str(j/17280),'%..'])
        end
    end
    total_count=count_0+count_1+count_2;
    results.timespent{1,i}=[count_0*100/total_count,count_1*100/total_count,count_2*100/total_count,total_count];
    display(['Done finding timespent for fish : ',num2str(i)])
end
            
                
                
                
                