function fhtrack_editframenumfunc

global gh

gh.data.cFrame = round(str2double(get(gh.disp.TextCFrame,'String')));
set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
set(gh.disp.SliderMain,'Value',(gh.data.cFrame-1)/(size(gh.data.ImRaw,3)-1));

gh.data.cMax=get(gh.disp.SliderCMax,'Value');
gh.data.cMin=get(gh.disp.SliderCMin,'Value');
gh.data.Gamma=get(gh.disp.SliderGamma,'Value');

fhtrack_dispdrawfunc;