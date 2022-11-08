function id=FAA_zoneid(y,x)

global zone

if isnan(y) | isnan(x) | y>300 | x>600 |y<=0 | x<=0
   id=NaN; 
elseif zone.BW_zone13(y,x)==1
    id=13;
elseif zone.BW_zone12(y,x)==1
    id=12;
elseif zone.BW_zone11(y,x)==1
    id=11;
elseif zone.BW_zone23(y,x)==1
    id=23;
elseif zone.BW_zone22(y,x)==1
    id=22;
elseif zone.BW_zone21(y,x)==1
    id=21;
elseif zone.BW_zone0(y,x)==1
    id=0;
else
    id=NaN;
end
