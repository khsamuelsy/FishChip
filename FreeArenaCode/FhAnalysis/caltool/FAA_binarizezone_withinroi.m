function zonelocate_binarizezone

global border zone

side_margin = 40;

BW_zone13=zeros(300,600,'logical');
BW_zone12=zeros(300,600,'logical');
BW_zone11=zeros(300,600,'logical');
BW_zone0=zeros(300,600,'logical');
BW_zone23=zeros(300,600,'logical');
BW_zone22=zeros(300,600,'logical');
BW_zone21=zeros(300,600,'logical');

BW_leftborder=zeros(300,600,'logical');
BW_rightborder=zeros(300,600,'logical');
BW_roi=zeros(300,600,'logical');

BW_roi(side_margin+1:end-side_margin,side_margin+1:end-side_margin)=1;

zone.BW_roi=BW_roi;


for i=1:300
    a=find(border.leftleftslope(:,2)==i);
    b=find(border.leftslope(:,2)==i);
    c=find(border.leftrightslope(:,2)==i);
    if size(a,1)~=0
        BW_zone13(1:border.leftleftslope(a,1),i)=1;
        if size(b,1)~=0
            BW_zone12(border.leftleftslope(a,1)+1:border.leftslope(b,1),i)=1;
            if size(c,1)~=0
                BW_zone11(border.leftslope(b,1)+1:border.leftrightslope(c,1),i)=1;
            end
        end
    elseif size(b,1)~=0
        BW_zone12(1:border.leftslope(b,1),i)=1;
        if size(c,1)~=0
                BW_zone11(border.leftslope(b,1)+1:border.leftrightslope(c,1),i)=1;
        end
    elseif size(c,1)~=0
        BW_zone11(1:border.leftrightslope(c,1),i)=1;
    end
end

for i=600:-1:301
    a=find(border.rightrightslope(:,2)==i);
    b=find(border.rightslope(:,2)==i);
    c=find(border.rightleftslope(:,2)==i);
    if size(a,1)~=0
        BW_zone23(1:border.rightrightslope(a,1),i)=1;
        if size(b,1)~=0
            BW_zone22(border.rightrightslope(a,1)+1:border.rightslope(b,1),i)=1;
            if size(c,1)~=0
                BW_zone21(border.rightslope(b,1)+1:border.rightleftslope(c,1),i)=1;
            end
        end
    elseif size(b,1)~=0
        BW_zone22(1:border.rightslope(b,1),i)=1;
        if size(c,1)~=0
                BW_zone21(border.rightslope(b,1)+1:border.rightleftslope(c,1),i)=1;
        end
    elseif size(c,1)~=0
        BW_zone21(1:border.rightleftslope(c,1),i)=1;
    end    
end

BW_zone23(:,max(border.rightslope(:,2)):600)=1;
BW_zone13(:,1:min(border.leftslope(:,2)))=1;

BW_roi=zone.BW_roi;
zone.BW_zone13=BW_zone13;
zone.BW_zone12=BW_zone12;
zone.BW_zone11=BW_zone11;

zone.BW_zone23=BW_zone23;

zone.BW_zone22=BW_zone22;
zone.BW_zone21=BW_zone21;

zone.BW_zone0=BW_roi&~BW_zone13&~BW_zone12  &~BW_zone11&~BW_zone23&~BW_zone22&~BW_zone21; 
