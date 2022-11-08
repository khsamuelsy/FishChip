for i=1:size(c,1)
    if c(i,3) >= 0.05
        c(i,4) ='ns';
    elseif c(i,3) >=0.01
        c(i,4) ='*';
    elseif c(i,3) >=0.001
         c(i,4) ='**';
    elseif c(i,3) >=0.001
         c(i,4) ='***';
    else
         c(i,4) ={'****'};
    end
        
end