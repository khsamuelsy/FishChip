function faa_shortlistbordercrossing

global results data

for i=1:size(results.allswimbout_details,2)
    in_flag=0;
    bordercrossing_details=[];
    for j=1:size(results.allswimbout_details{1,i},1)
        
        if results.allswimbout_details{1,i}(j,8)>results.allswimbout_details{1,i}(j,7)

            in_flag=1;
            in_dnormalangle=results.allswimbout_details{1,i}(j,18);
            if results.allswimbout_details{1,i}(j,1)~=0
                in_framen=results.allswimbout_details{1,i}(j,4);
            else
                in_framen=results.allswimbout_details{1,i}(j,3);
            end
            start_framen=results.allswimbout_details{1,i}(j,2);
            in_zone1=results.allswimbout_details{1,i}(j,7);
            in_zone2=results.allswimbout_details{1,i}(j,8);
            border_normal=results.allswimbout_details{1,i}(j,19);
           
        elseif (results.allswimbout_details{1,i}(j,8)<results.allswimbout_details{1,i}(j,7) ...
                | results.allswimbout_details{1,i}(j,8) ~=0 ...
                | results.allswimbout_details{1,i}(j,7) ~=0) ...
                & in_flag==1 ...
                & results.allswimbout_details{1,i}(j,7)==in_zone2
            in_flag=0;
            dang=results.allswimbout_details{1,i}(j,9);
            next_zone1=results.allswimbout_details{1,i}(j,7);
            next_zone2=results.allswimbout_details{1,i}(j,8);
            next_framen=results.allswimbout_details{1,i}(j,2);
            if results.allswimbout_details{1,i}(j,1)~=0
                end_framen=results.allswimbout_details{1,i}(j,4);
            else
                end_framen=results.allswimbout_details{1,i}(j,3);
            end
            
            latency=next_framen-in_framen;
            bordercrossing_details=[bordercrossing_details; ...
                start_framen,in_framen,next_framen,end_framen, ... 
                in_zone1,in_zone2, ...
                next_zone1,next_zone2, ...
                in_dnormalangle,dang, ...
                latency,border_normal];
            

        end
    end
    results.bordercrossing_details{1,i}=bordercrossing_details;
end
        
            
            
% count
        