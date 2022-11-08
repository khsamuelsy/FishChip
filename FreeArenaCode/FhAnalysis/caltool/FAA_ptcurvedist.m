function dist=zonelocate_ptcurvedist(y,x,i,j,results)

global data border 

zonelocate_loadborder

if results.bordercrossing_details{1,i}(j,5)==0 &&  results.bordercrossing_details{1,i}(j,6)<20 
    curve = border.leftrightslope;
elseif results.bordercrossing_details{1,i}(j,5)==11
    curve = border.leftslope;
elseif results.bordercrossing_details{1,i}(j,5)==12
    curve = border.leftleftslope;
elseif results.bordercrossing_details{1,i}(j,5)==0  &&  results.bordercrossing_details{1,i}(j,6)>20
    curve = border.rightleftslope;
elseif results.bordercrossing_details{1,i}(j,5)==21
    curve = border.rightslope;
elseif results.bordercrossing_details{1,i}(j,5)==22
    curve = border.rightrightslope;

end

for m=1:size(curve,1)
    pairwise_dist(m)=pdist([y x; curve(m,1) curve(m,2)]);
end

dist=min(pairwise_dist);



    

