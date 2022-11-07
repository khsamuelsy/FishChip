global gh
gh.param.losttrackframe=[];
gh.param.losttrackframe2=[];
for k=1:gh.data.sze(3)
    for FhIdx=1:size(gh.data.FhCoor,2)
        if k<=size(gh.data.FhCoor{1,FhIdx},1)
            tempx=gh.data.FhCoor{1,FhIdx}(k,1);
            tempy=gh.data.FhCoor{1,FhIdx}(k,2);
        end
        for compFhIdx=1:size(gh.data.FhCoor,2)
            if compFhIdx ~= FhIdx & k<=size(gh.data.FhCoor{1,compFhIdx},1)
                temp2x=gh.data.FhCoor{1,compFhIdx}(k,1);
                temp2y=gh.data.FhCoor{1,compFhIdx}(k,2);
                dist=sqrt((temp2x-tempx).^2+(temp2y-tempy).^2);
                if dist<10
                    if ~any(gh.param.losttrackframe(:)==k)
                        gh.param.losttrackframe=[gh.param.losttrackframe,k];
                    end
                end
            end
        end
    end
end
for i=size(gh.param.losttrackframe,2):-1:2

    if (gh.param.losttrackframe(1,i)-gh.param.losttrackframe(1,(i-1))==1)
        gh.param.losttrackframe(i)=[];
    end
    
end

if ~isempty(gh.param.losttrackframe)
%     fhtrack_alert;
    for i=1:size(gh.param.losttrackframe,2)
        temp=gh.param.losttrackframe(1,i);
        display(strcat('Meet at frame','--',num2str(temp)));
    end

    k=2;
    while k~=0
        if k==1
            if gh.param.losttrackframe(1)~=1
                gh.data.cFrame=gh.param.losttrackframe(1)-1;
            else
                gh.data.cFrame=gh.param.losttrackframe(1);
            end
            fhtrack_dispdrawfunc;
            
        elseif k==2
            gh.data.cFrame=gh.param.losttrackframe(1);
            fhtrack_dispdrawfunc;
            pause(1.5)
        end
   
        set(gh.disp.SliderMain,'Value',gh.data.cFrame/gh.data.sze(3));
        set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
        k=k-1;
    end
        
    

end

% for k=1:gh.data.sze(3)
%     for FhIdx=1:size(gh.data.FhCoor,2)
%         if k<=size(gh.data.FhCoor{1,FhIdx},1)
%             tempx=gh.data.FhCoor{1,FhIdx}(k,1);
%             tempy=gh.data.FhCoor{1,FhIdx}(k,2);
%         end
%         if tempy<20 | tempy>624 | tempx <20 | tempx >464
%             if ~any(gh.param.losttrackframe2(:)==k)
%                 gh.param.losttrackframe2=[gh.param.losttrackframe2,k];
%             end
%         end
%     end
% end
% for i=size(gh.param.losttrackframe2,2):-1:2
% 
%     if (gh.param.losttrackframe2(1,i)-gh.param.losttrackframe2(1,(i-1))==1)
%         gh.param.losttrackframe2(i)=[];
%     end
%     
% end
% if ~isempty(gh.param.losttrackframe2)
%     fhtrack_alert
%     for i=1:size(gh.param.losttrackframe2,2)
%         temp=gh.param.losttrackframe2(1,i);
%         fprintf("BORDER: frame %s\n",num2str(temp));
%     end
% end
%                     
%                 
%         
    