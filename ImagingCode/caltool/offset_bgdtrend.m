function output=offset_bgdtrend(input)

% suppose there is a constant decreaseing or increasing rate

% threshold : 10e-4


if size([1:length(input)])~=size(input)
    p = polyfit([1:length(input)],input',1);
else
    p = polyfit([1:length(input)],input,1);
end
    

p2 = polyfit(reshape(1:30,30,1),reshape(input(1:30),30,1),1);
% display(['Slope is :',num2str(p(1))]);
output=input;
if abs(p(1))> 1e-4
    for ii=1:length(input)
        output(ii) = - p2(1).*(ii-1) + input(ii);
    end
end
