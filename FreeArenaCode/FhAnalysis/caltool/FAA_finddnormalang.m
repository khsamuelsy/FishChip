function normalang=zonelocate_findnormalang(array,y,x)


for i=1:size(array,1)
    dist(i,1)=pdist([array(i,:);y,x]); 
end

m=find(dist==min(dist));


if m>3 & m<size(dist,1)-3
    p=polyfit(array(m-3:m+3,1)',array(m-3:m+3,2)',1);
    slope=p(1);
elseif m<=3
    p=polyfit(array(m:m+6,1)',array(m:m+6,2)',1);
    slope=p(1);
elseif m>=size(dist,1)-3
    p=polyfit(array(m-6:m,1)',array(m-6:m,2)',1);
    slope=p(1);
end

normalang=radtodeg(atan(slope));

if normalang<0
    normalang=360+normalang;
    normalang=normalang-90;
else
    normalang=normalang+90;
end
