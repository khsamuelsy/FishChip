function dang=zonelocate_dang(a,b)

dang_1=abs(a-b);

if a>b
    dang_2=360-a+b;
else
    dang_2=360-b+a;
end

if dang_1<=dang_2
    dang=dang_1;
else
    dang=dang_2;
end
