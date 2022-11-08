function FAA_findswim

global  results parameters data

fperiod=1000/240;

data.nofframe=1728000;
parameters.nonforwardframe = zeros(data.nofframe,data.noffish,'logical');
parameters.nonforwardframe(:,:) = 1;
parameters.idleframe = zeros(data.nofframe,data.noffish,'logical');
results.allswimbout_details={};
results.turnandslide_details={};
results.forward_details={};

for i=1:data.noffish
    tic
    % flag idle events , min false positive by imposing constrain that
    % account for fast and slow turns
    
    for j=1:data.nofframe-4
        if (FAA_dang(data.FhAng{1,i}(j),data.FhAng{1,i}(j+1))<=10 && pdist([data.FhCoor{1,i}(j,:);data.FhCoor{1,i}(j+1,:)])<=2) ...
                && (FAA_dang(data.FhAng{1,i}(j),data.FhAng{1,i}(j+2))<=10 && pdist([data.FhCoor{1,i}(j,:);data.FhCoor{1,i}(j+2,:)])<=2) ...
                && (FAA_dang(data.FhAng{1,i}(j),data.FhAng{1,i}(j+3))<=10 && pdist([data.FhCoor{1,i}(j,:);data.FhCoor{1,i}(j+3,:)])<=2) ...
                && (FAA_dang(data.FhAng{1,i}(j),data.FhAng{1,i}(j+4))<=10 && pdist([data.FhCoor{1,i}(j,:);data.FhCoor{1,i}(j+4,:)])<=2) ...
                parameters.idleframe(j,i)=1;
        elseif isnan(data.FhCoor{1,i}(j,1)) || isnan(data.FhCoor{1,i}(j+1,1))
                parameters.idleframe(j,i)=1;
        end
    end
    
    % min false positive of singular events (frame n < 2)
    
    for j=2:data.nofframe-3
        if parameters.idleframe(j,i)==0
            if parameters.idleframe(j+1,i)==1 && parameters.idleframe(j-1,i)==1 ...
                    || parameters.idleframe(j+2,i)==1 && parameters.idleframe(j-1,i)==1
                parameters.idleframe(j,i)=1;
            end
        end
    end
    parameters.idleframe(data.nofframe-4:data.nofframe,i)=[1,1,1,1,1];
    
    % identify turn events and subsequent slide events
    turnstartcoordy = [];    turnstartcoordx = [];
    turnstartang = [];    turnstartzoneid = [];
    turnendcoordy = [];    turnendcoordx = [];
    turnendang=[];    turnendzoneid = [];
    dist = [];    turndang = [];
    slideendcoordy=[];    slideendcoordx=[];
    totaldist=[];    slideendzoneid=[];
    slideendang=[];    startf = [];
    endf = [];    slideendf = [];
    turntype = [];      
    
    for j=2:data.nofframe-2
        if parameters.idleframe(j,i)==0 && parameters.idleframe(j-1,i)~=0
            startf=[startf;j];
        end
        if parameters.idleframe(j,i)==1 && parameters.idleframe(j-1,i)~=1 ...
                && ~isempty(startf)
            endf=[endf;j];
        end
    end
    
    if size(endf,1)~=size(startf,1)
        endf=[endf;NaN];
    end
    

    for j=1:size(startf,1)
        if FAA_dang(data.FhAng{1,i}(startf(j)),data.FhAng{1,i}(startf(j)+1))>10 ... 
            || FAA_dang(data.FhAng{1,i}(startf(j)),data.FhAng{1,i}(startf(j)+2))>10 ...
            || FAA_dang(data.FhAng{1,i}(startf(j)),data.FhAng{1,i}(startf(j)+3))>10
            turntype(j,1)=1;
        else
            turntype(j,1)=2;
        end
        
        stopslide_flag=0;
        framen=endf(j,1);
        
        while stopslide_flag==0 && framen<data.nofframe-(50/(1000/240))*2
            if turntype(j,1)==1
                test_stepf=2;
            elseif turntype(j,1)==2
                test_stepf=50/(1000/240);
            end
            if ((pdist([data.FhCoor{1,i}(framen,:);data.FhCoor{1,i}(framen+1*test_stepf,:)])<=2 ...
                    && pdist([data.FhCoor{1,i}(framen,:);data.FhCoor{1,i}(framen+2*test_stepf,:)])<=2)) ...
                    || isnan(data.FhCoor{1,i}(framen+1,1))
                stopslide_flag=1;
                slideendf(j,1)=framen; 
            else
                framen=framen+1;  
            end
        end
        if j>size(slideendf,1)
            slideendf(j,1)=NaN;
        end
        turnstartcoordy(j,1)=data.FhCoor{1,i}(startf(j),1);
        turnstartcoordx(j,1)=data.FhCoor{1,i}(startf(j),2);
        turnstartang(j,1)=data.FhAng{1,i}(startf(j));
        turnstartzoneid(j,1)=FAA_zoneid(turnstartcoordy(j,1),turnstartcoordx(j,1));
        
        if isnan(endf(j,1))
            turnendcoordy(j,1)=NaN;
            turnendcoordx(j,1)=NaN;
            turnendzoneid(j,1)=NaN;
            turndist(j,1)=NaN;
        else
            turnendcoordy(j,1)=data.FhCoor{1,i}(endf(j),1);
            turnendcoordx(j,1)=data.FhCoor{1,i}(endf(j),2);
            turnendzoneid(j,1)=FAA_zoneid(turnendcoordy(j,1),turnendcoordx(j,1));
            turndist(j,1)=round(pdist([turnstartcoordy(j,1),turnstartcoordx(j,1);turnendcoordy(j,1),turnendcoordx(j,1)]));
            turndang(j,1)=data.FhAng{1,i}(endf(j));
        end
        
        if isnan(slideendf(j,1))
            slideendcoordy(j,1)=NaN;
            slideendcoordx(j,1)=NaN;
            totaldist(j,1)=NaN;
            slideendzoneid(j,1)=NaN;
            turndang(j,1)=NaN;
            turnendang(j,1)=NaN;
            slideendang(j,1)=NaN;
        else
            slideendang(j,1)=data.FhAng{1,i}(slideendf(j));
            turndang(j,1)=FAA_dang_wdir(turnstartang(j,1),turndang(j,1));
            slideendcoordy(j,1)=data.FhCoor{1,i}(slideendf(j),1);
            slideendcoordx(j,1)=data.FhCoor{1,i}(slideendf(j),2);
            if ~isnan(slideendcoordy(j,1)) && ~isnan(slideendcoordx(j,1))
            totaldist(j,1)=round(pdist([turnstartcoordy(j,1),turnstartcoordx(j,1);slideendcoordy(j,1),slideendcoordx(j,1)]));
            slideendzoneid(j,1)=FAA_zoneid(slideendcoordy(j,1),slideendcoordx(j,1));
            else 
                slideendzoneid(j,1)=NaN;
                totaldist(j,1)=NaN;
            end
        end
    end

    results.turnandslide_details{1,i}=[turntype,startf,endf,slideendf, ...
        slideendf-startf,totaldist, ...
        turnstartzoneid,slideendzoneid, ...
        turndang, ...
        turnstartcoordy,turnstartcoordx, ...
        turnendcoordy,turnendcoordx, ...
        slideendcoordy,slideendcoordx, ...
        turnstartang,slideendang];        
    j=1;
    while j<=size(results.turnandslide_details{1,i},1)
        if results.turnandslide_details{1,i}(j,6)<=8
            results.turnandslide_details{1,i}(j,:)=[];
        elseif j~=1 && (results.turnandslide_details{1,i}(j,2) < results.turnandslide_details{1,i}(j-1,4))
            results.turnandslide_details{1,i}(j,:)=[];
        else           
            j=j+1;
        end

    end
    
    % identify forward events and subsequent slide events
    for j=1:data.nofframe-3
        if (pdist([data.FhCoor{1,i}(j,:);data.FhCoor{1,i}(j+3,:)])>2 ...
                && parameters.idleframe(j,i)==1) 
            parameters.nonforwardframe(j,i)=0;
        end
        if isnan(data.FhCoor{1,i}(j,1)) || isnan(data.FhCoor{1,i}(j+1,1))
                parameters.nonforwardframe(j,i)=1;
        end
    end
    
    for j=2:data.nofframe-6
        if parameters.nonforwardframe(j,i)==0
            if parameters.nonforwardframe(j+1,i)==1 && parameters.nonforwardframe(j-1,i)==1 ...
                    || parameters.nonforwardframe(j+2,i)==1 && parameters.nonforwardframe(j-1,i)==1
                parameters.nonforwardframe(j,i)=1;
            
            end
        end
    end
    forward_startf=[];
    forward_endf=[];
    
    for j=2:data.nofframe-2
        if parameters.nonforwardframe(j,i)==0 && parameters.nonforwardframe(j-1,i)~=0
            forward_startf=[forward_startf;j];
        end
        if parameters.nonforwardframe(j,i)==1 && parameters.nonforwardframe(j-1,i)~=1 ...
                && ~isempty(forward_startf)
            forward_endf=[forward_endf;j-1];
        end
    end
    
    if size(forward_endf,1)~=size(forward_startf,1)
        forward_endf=[forward_endf;NaN];
    end
    forward_startcoordy = [];    forward_startcoordx = [];
    forward_startang = [];    forward_startzoneid = [];
    forward_turntype = [];    forward_nullcolumn = [];
    forward_endcoordy = [];    forward_endcoordx = [];
    forward_endang = [];    forward_endzoneid = [];
    forward_dist = [];    forward_dang = [];
    for j=1:size(forward_startf,1)
        forward_startcoordy(j,1)=data.FhCoor{1,i}(forward_startf(j),1);
        forward_startcoordx(j,1)=data.FhCoor{1,i}(forward_startf(j),2);
        forward_startang(j,1)=data.FhAng{1,i}(forward_startf(j));
        forward_startzoneid(j,1)=FAA_zoneid(forward_startcoordy(j,1),forward_startcoordx(j,1));
        forward_turntype(j,1)=0;
        forward_nullcolumn(j,1)=NaN;
        if isnan(forward_endf(j,1))
            forward_endcoordy(j,1)=NaN;
            forward_endcoordx(j,1)=NaN;
            forward_endang(j,1)=NaN;
            forward_endzoneid(j,1)=NaN;
            forward_dist(j,1)=NaN;
            forward_dang(j,1)=NaN;
        else
            forward_endcoordy(j,1)=data.FhCoor{1,i}(forward_endf(j),1);
            forward_endcoordx(j,1)=data.FhCoor{1,i}(forward_endf(j),2);
            forward_endang(j,1)=data.FhAng{1,i}(forward_endf(j));
            forward_endzoneid(j,1)=FAA_zoneid(forward_endcoordy(j,1),forward_endcoordx(j,1));
            forward_dist(j,1)=round(pdist([forward_startcoordy(j,1),forward_startcoordx(j,1);forward_endcoordy(j,1),forward_endcoordx(j,1)]));
            forward_dang(j,1)=FAA_dang_wdir(forward_startang(j,1),forward_endang(j,1));
        end
    end
    results.forward_details{1,i}=[forward_turntype,forward_startf,forward_endf,forward_nullcolumn, ...
        forward_endf-forward_startf,forward_dist, ...
        forward_startzoneid,forward_endzoneid, ...
        forward_dang, ...
        forward_startcoordy,forward_startcoordx, ...
        forward_nullcolumn,forward_nullcolumn, ...
        forward_endcoordy,forward_endcoordx, ...
        forward_startang, forward_endang];
    j=1;
    
    % min false positive i.e. trivial movement
    
    while j<=size(results.forward_details{1,i},1)
        if results.forward_details{1,i}(j,6)<=8
            results.forward_details{1,i}(j,:)=[];
        else
            j=j+1;
        end
    end
    
    results.allswimbout_details{1,i} = [results.turnandslide_details{1,i};results.forward_details{1,i}];
    if ~isempty(results.allswimbout_details{1,i})
        results.allswimbout_details{1,i} = sortrows(results.allswimbout_details{1,i},2);
    end
    j=2;
    while j<=size(results.allswimbout_details{1,i},1)
        
        if j~=1 & (results.allswimbout_details{1,i}(j,2) < results.allswimbout_details{1,i}(j-1,4))
            results.allswimbout_details{1,i}(j,:)=[];
        elseif (results.allswimbout_details{1,i}(j,2)-results.allswimbout_details{1,i}(j-1,3))==1 ...
                & results.allswimbout_details{1,i}(j,1) == 0 ...
                & results.allswimbout_details{1,i}(j-1,1) == 0
            
            results.allswimbout_details{1,i}(j-1,3)=results.allswimbout_details{1,i}(j,3);
            results.allswimbout_details{1,i}(j-1,5)=results.allswimbout_details{1,i}(j-1,5)+results.allswimbout_details{1,i}(j,5)+1;
            results.allswimbout_details{1,i}(j-1,6)=results.allswimbout_details{1,i}(j-1,6)+results.allswimbout_details{1,i}(j,6)+1;
            results.allswimbout_details{1,i}(j-1,8)=results.allswimbout_details{1,i}(j,8);
            results.allswimbout_details{1,i}(j-1,9)=FAA_dang_wdir(results.allswimbout_details{1,i}(j-1,16),results.allswimbout_details{1,i}(j-1,17));
            results.allswimbout_details{1,i}(j-1,14)=results.allswimbout_details{1,i}(j,14);
            results.allswimbout_details{1,i}(j-1,15)=results.allswimbout_details{1,i}(j,15);
            results.allswimbout_details{1,i}(j-1,16)=results.allswimbout_details{1,i}(j-1,16);
            results.allswimbout_details{1,i}(j-1,17)=results.allswimbout_details{1,i}(j,17);   
        else     
            j=j+1;    
        end
    end       
    display(['Done finding swim events of fish :',num2str(i)])
    toc
end
for i=1:data.noffish
    results.idleevent_perc(i) = nnz(parameters.idleframe(:,i))*100/data.nofframe;
end
faa_findcrossborderangle;
faa_shortlistbordercrossing;