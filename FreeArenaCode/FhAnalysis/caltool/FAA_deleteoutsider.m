function outputarray=FAA_deleteoutsider(array)

i=1;
while (i<=size(array,1))
    if array(i,1)>300 | array(i,1)<0 ...
            | array(i,2)>600 | array(i,2)<0
       array(i,:)=[];
    else
       i=i+1; 
    end
    
end

outputarray=array;
    