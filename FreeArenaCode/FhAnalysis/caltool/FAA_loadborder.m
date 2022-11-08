function FAA_loadborder

global border

CurrentDir = pwd;
try
    load([CurrentDir(1:end-54),'Data\border\20180411.mat']);
catch
    load([CurrentDir(1:end-46),'Data\border\20180411.mat']);
end
border.leftCoorTform=[1 0; 0 -1]*Zonelocate_data.rightCoorTform+[0;600];
border.rightCoorTform=[1 0;0 -1]*Zonelocate_data.leftCoorTform+[0;600];

border.avg_leftslope = [];
border.avg_rightslope = [];

border.coeff_leftslope = [];
border.coeff_rightslope = [];

border.leftslope=[];
border.rightslope=[];
border.leftleftslope=[];
border.leftrightslope=[];
border.rightleftslope=[];
border.rightrightslope=[];

border_margin = 10;
step = 8;


for i=1:300
    k = find(round(border.leftCoorTform(2,:))==i);
    avg_y=0;
    for j=1:size(k,2)
            avg_y=(avg_y*(j-1)+round(border.leftCoorTform(1,k(j))))/j;
    end
    avg_y=round(avg_y);
    if size(k,2)~=0
        border.avg_leftslope = [border.avg_leftslope; avg_y, i];
    end
end

for i=301:600
    k = find(round(border.rightCoorTform(2,:))==i);
    avg_y=0;
    for j=1:size(k,2)

            avg_y=(avg_y*(j-1)+round(border.rightCoorTform(1,k(j))))/j;

    end
    avg_y=round(avg_y);
    if ~size(k,2)==0
        border.avg_rightslope = [border.avg_rightslope; avg_y, i];
    end
end

for i=min(min(border.avg_leftslope(:,2))):step:(max(max(border.avg_leftslope(:,2)))-step)
    k=find(border.avg_leftslope(:,2)==i);
    p=polyfit(border.avg_leftslope(k:k+step,2),-border.avg_leftslope(k:k+step,1),1);
    border.coeff_leftslope(i,1:3)=[p(1),p(2),round(180+radtodeg(atan(p(1))))];
end

for i=min(min(border.avg_leftslope(:,2))):step:(max(max(border.avg_leftslope(:,2)))-step)
    border_y(i:i+step)=round(polyval([border.coeff_leftslope(i,1),border.coeff_leftslope(i,2)],[i:i+step]));
    for j=i:i+step
        border_y(j);
    end
end


border_y=-border_y;
border.leftslope=[border_y(1,min(min(border.avg_leftslope(:,2))):end)', [min(min(border.avg_leftslope(:,2))):size(border_y,2)]'];
border_y = [];


for i=min(min(border.avg_rightslope(:,2))):step:(max(max(border.avg_rightslope(:,2)))-step)
    k=find(border.avg_rightslope(:,2)==i);
    p=polyfit(border.avg_rightslope(k:k+step,2),-border.avg_rightslope(k:k+step,1),1);
    border.coeff_rightslope(i,1:3)=[p(1),p(2),round(180+radtodeg(atan(p(1))))];
end

for i=min(min(border.avg_rightslope(:,2))):step:(max(max(border.avg_rightslope(:,2)))-step)

    border_y(i:i+step)=round(polyval([border.coeff_rightslope(i,1),border.coeff_rightslope(i,2)],[i:i+step]));
    for j=i:i+step
        border_y(j);
    end
end


border_y=-border_y;
border.rightslope=[border_y(1,min(min(border.avg_rightslope(:,2))):end)', [min(min(border.avg_rightslope(:,2))):size(border_y,2)]'];


%Calculate auxillary borders;
eff_leftleftslope=[];
eff_leftrightslope=[];
eff_rightleftslope=[];
eff_rightrightslope=[];

diff=border.leftslope(end,2)-size(border.coeff_leftslope,1);
if diff>0
    border.coeff_leftslope(end+1:end+diff,:)=zeros(diff,3);
end

diff=border.rightslope(end,2)-size(border.coeff_rightslope,1);
if diff>0
    border.coeff_rightslope(end+1:end+diff,:)=zeros(diff,3);
end



for i=1:size(border.leftslope,1)
    temp_x=border.leftslope(i,2);
    if border.coeff_leftslope(temp_x,3)~=0
        temp_ang=border.coeff_leftslope(temp_x,3);
    end
   eff_leftleftslope=round([eff_leftleftslope;border.leftslope(i,1)+border_margin.*cosd(temp_ang),border.leftslope(i,2)+border_margin.*sind(temp_ang)]);
   eff_leftrightslope=round([eff_leftrightslope;border.leftslope(i,1)-border_margin.*cosd(temp_ang),border.leftslope(i,2)-border_margin.*sind(temp_ang)]);
end

for i=1:size(border.rightslope,1)
    temp_x=border.rightslope(i,2);
    if border.coeff_rightslope(temp_x,3)~=0
        temp_ang=border.coeff_rightslope(temp_x,3);
    end
   eff_rightleftslope=round([eff_rightleftslope;border.rightslope(i,1)-border_margin.*cosd(temp_ang),border.rightslope(i,2)-border_margin.*sind(temp_ang)]);
   eff_rightrightslope=round([eff_rightrightslope;border.rightslope(i,1)+border_margin.*cosd(temp_ang),border.rightslope(i,2)+border_margin.*sind(temp_ang)]);
end

i=1;
while i<size(eff_leftleftslope,1)
    k=find(eff_leftleftslope(i:end,2)==eff_leftleftslope(i,2));

    avg_y=mean(eff_leftleftslope(i:i+size(k,1)-1,1));
    if size(k,1)>1
        eff_leftleftslope((i+1):(i+size(k,1))-1,:)=[];
    end
    i=i+1;
end

i=1;
while i<size(eff_leftrightslope,1)
    k=find(eff_leftrightslope(i:end,2)==eff_leftrightslope(i,2));

    avg_y=mean(eff_leftrightslope(i:i+size(k,1)-1,1));
    if size(k,1)>1
        eff_leftrightslope((i+1):(i+size(k,1))-1,:)=[];
    end
    i=i+1;
end
    
i=1;
while i<size(eff_rightrightslope,1)
    k=find(eff_rightrightslope(i:end,2)==eff_rightrightslope(i,2));

    avg_y=mean(eff_rightrightslope(i:i+size(k,1)-1,1));
    if size(k,1)>1
        eff_rightrightslope((i+1):(i+size(k,1))-1,:)=[];
    end
    i=i+1;
end

i=1;
while i<size(eff_rightleftslope,1)
    k=find(eff_rightleftslope(i:end,2)==eff_rightleftslope(i,2));

    avg_y=mean(eff_rightleftslope(i:i+size(k,1)-1,1));
    if size(k,1)>1
        eff_rightleftslope((i+1):(i+size(k,1))-1,:)=[];
    end
    i=i+1;
end

border.leftleftslope=round(FAA_fillarray(FAA_deleteoutsider(eff_leftleftslope)));
border.leftrightslope=round(FAA_fillarray(FAA_deleteoutsider(eff_leftrightslope)));
border.rightleftslope=round(FAA_fillarray(FAA_deleteoutsider(eff_rightleftslope)));
border.rightrightslope=round(FAA_fillarray(FAA_deleteoutsider(eff_rightrightslope)));

FAA_binarizezone;
% FAA_binarizezone_withinroi;
% display('Loaded border');