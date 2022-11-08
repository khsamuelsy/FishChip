function framen = FAA_findtransistionframen(startf,endf,fishn)

global data 

i=fishn;

for j=startf:endf-1
     if FAA_zoneid(data.FhCoor{1,i}(j,1),data.FhCoor{1,i}(j,2)) ~= ...
            FAA_zoneid(data.FhCoor{1,i}(j+1,1),data.FhCoor{1,i}(j+1,2))
        framen=j;
        break
     end
end


