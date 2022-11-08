function mycolor=FishyChemoBehav_ColorPlate
mycolor.baseline = [100 100 100]./255; % black
mycolor.mainleft = [47 85 151]./255; % blue
mycolor.mainright = [192 0 0]./255; % red
mycolor.mainbi = [112 48 160]./255; % magneta
% mycolor.mainnull = [7 173 98]*.75./255; %grass green
mycolor.mainnull = [0 0 0]./255; % black

mycolor.linestyle.baseline=':';
mycolor.linestyle.mainleft='--';
mycolor.linestyle.mainright='-.';
mycolor.linestyle.mainbi='-';
mycolor.linestyle.mainnull=':';
end