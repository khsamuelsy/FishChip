global gh

for k=0:100:gh.data.sze(3)
    if k==0
        gh.data.cFrame=1;
    else
        gh.data.cFrame=k;
    end
    fhtrack_dispdrawfunc;
    set(gh.disp.SliderMain,'Value',k/gh.data.sze(3));
    set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
    pause(0.08)
end

    
    