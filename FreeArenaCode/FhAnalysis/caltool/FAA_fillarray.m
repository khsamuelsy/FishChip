function outputarray=FAA_fillarray(array)

temp_x=array(1,2);        
for i=2:size(array,1)-1
    
    k=find(array(:,2)==temp_x);
    if size(k,1)==0
        u=find(array(:,2)==(temp_x-1));
        if size(u,1)~=0
            temp_y=(array(u,1)+array(u+1,1))/2;
            temp_array=[array(1:u,:);temp_y, temp_x;array(u+1:end,:)];
            array=temp_array;
        end
    end
    temp_x=temp_x+1;
end

outputarray=array;