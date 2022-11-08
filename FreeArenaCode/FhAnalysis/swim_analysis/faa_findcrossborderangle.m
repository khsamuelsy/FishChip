function faa_findcrossborderangle

global border data results 

slope=[];
  


%default normal angle pointing to the '0' zone

for i=1:data.noffish
    crossborderangle=[];
    normal_angle=[];
    for j=1:size(results.allswimbout_details{1,i},1)
        startf=results.allswimbout_details{1,i}(j,2);
        if results.allswimbout_details{1,i}(j,1)~=0
            endf=results.allswimbout_details{1,i}(j,4);
        else
            endf=results.allswimbout_details{1,i}(j,3);
        end
        if results.allswimbout_details{1,i}(j,7)==results.allswimbout_details{1,i}(j,8)
            crossborderangle=[crossborderangle;NaN];
            normal_angle=[normal_angle;NaN];
        elseif isnan(endf)
            crossborderangle=[crossborderangle;NaN];
            normal_angle=[normal_angle;NaN];
        elseif results.allswimbout_details{1,i}(j,7)<14 & results.allswimbout_details{1,i}(j,7)>10 ...
                | results.allswimbout_details{1,i}(j,8)<14 & results.allswimbout_details{1,i}(j,8)>10
            if results.allswimbout_details{1,i}(j,8)>results.allswimbout_details{1,i}(j,7)
                framen=FAA_findtransistionframen(startf,endf,i);
                if results.allswimbout_details{1,i}(j,7) == 0
                    normalang=FAA_finddnormalang(border.leftrightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 11
                    normalang=FAA_finddnormalang(border.leftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 12
                    normalang=FAA_finddnormalang(border.leftleftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                end
            else
                framen=FAA_findtransistionframen(startf,endf,i);
                if results.allswimbout_details{1,i}(j,7) == 13
                    normalang=FAA_finddnormalang(border.leftleftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))-180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 12
                    normalang=FAA_finddnormalang(border.leftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))-180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 11
                    normalang=FAA_finddnormalang(border.leftrightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))-180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                end
            end
            crossborderangle=[crossborderangle;dnormalang];
            normal_angle=[normal_angle;normalang];
        elseif results.allswimbout_details{1,i}(j,7)<24 & results.allswimbout_details{1,i}(j,7)>20 ...
                | results.allswimbout_details{1,i}(j,8)<24 & results.allswimbout_details{1,i}(j,8)>20
            if results.allswimbout_details{1,i}(j,8)>results.allswimbout_details{1,i}(j,7)
 
                framen=FAA_findtransistionframen(startf,endf,i);
                if results.allswimbout_details{1,i}(j,7) == 0
                    normalang=FAA_finddnormalang(border.rightleftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 21
                    normalang=FAA_finddnormalang(border.rightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 22
                    normalang=FAA_finddnormalang(border.rightrightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2));
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                end
            else
                framen=FAA_findtransistionframen(startf,endf,i);
                if results.allswimbout_details{1,i}(j,7) == 23
                    normalang=FAA_finddnormalang(border.rightrightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))+180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 22
                    normalang=FAA_finddnormalang(border.rightslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))+180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                elseif results.allswimbout_details{1,i}(j,7) == 21
                    normalang=FAA_finddnormalang(border.rightleftslope,data.FhCoor{1,i}(framen,1),data.FhCoor{1,i}(framen,2))+180;
                    dnormalang=FAA_dang_wdir(normalang,data.FhAng{1,i}(framen));
                end
            end
            crossborderangle=[crossborderangle;dnormalang];
            normal_angle=[normal_angle;normalang];
        end
    end
 
    if ~isempty(results.allswimbout_details{1,i})
        results.allswimbout_details{1,i}(:,18)=crossborderangle;
        results.allswimbout_details{1,i}(:,19)=normal_angle;
    end
end
                    
                    
                    
                
                
        
                
                
                