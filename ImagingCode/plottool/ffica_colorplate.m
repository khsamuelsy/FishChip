function ffica_colorplate


global mycolor

mycolor.baseline = [0 0 0]./255; % black
mycolor.mainleft = [47 85 151]./255; % blue
mycolor.mainright = [192 0 0]./255; % red
mycolor.mainbi = [112 48 160]./255; % magneta

mycolor.syn_max = mycolor.mainbi;
mycolor.syn_min = [0 255 0]./255;
mycolor.syn_half = (mycolor.syn_max+mycolor.syn_min)./2;
% activity_max = [230 75 53]./255;

mycolor.activity = min((copper).*1.6,1);

mycolor.lr  = []./255;
for ii=0:100
    mycolor.lr = [mycolor.lr ;...
    mycolor.mainright.*(1-ii/100)+mycolor.mainbi.*ii/100];
end

for ii=1:100
    mycolor.lr = [mycolor.lr ;...
    mycolor.mainleft.*ii/100+mycolor.mainbi.*(1-ii/100)];
end

end

